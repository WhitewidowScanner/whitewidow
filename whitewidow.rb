#!/usr/local/env ruby

require_relative 'lib/imports/constants_and_requires'

#
# Usage page, basic help page for commands
#
def usage_page
  FORMAT.info("ruby #{File.basename(__FILE__)} -[OPTIONS] --[OPTIONAL-OPTIONS]")
  FORMAT.info("Check the README.md file for a list of flags and further information")
  system('ruby whitewidow.rb --help')
  exit
end

#
# Append into the OPTIONS constant so that we can call the flag from the constant instead of a class
#
OptionParser.new do |opt|
  opt.on('-f FILE', '--file FILE', 'Pass a filename to scan')                             { |o| OPTIONS[:file]    = o }
  opt.on('-s URL', '--spider URL', 'Spider a web page and save all the URLS')             { |o| OPTIONS[:spider]  = o }
  opt.on('-d', '--default', "Run in default mode, scrape Google")                         { |o| OPTIONS[:default] = o }
  opt.on('-l', '--legal', 'Show the legal information and the TOS')                       { |o| OPTIONS[:legal]   = o }
  opt.on('--proxy IP:PORT', 'Configure to run with a proxy, must use ":"')                { |o| OPTIONS[:proxy]   = o }
  opt.on('--run-x NUM', Integer, 'Run the specified amount of dry runs')                  { |o| OPTIONS[:run]     = o }
  opt.on('--banner', 'Run without displaying the banner')                                 { |o| OPTIONS[:banner]  = o }
  opt.on('--dry-run', 'Save the sites to the SQL_sites_to_check file only, no checking.') { |o| OPTIONS[:dry]     = o }
  opt.on('--batch', 'No prompts, used in conjunction with the dry run')                   { |o| OPTIONS[:batch]   = o }
  opt.on('--beep', 'Make a beep when the program finds a vulnerability')                  { |o| OPTIONS[:beep]    = o }
  opt.on('--rand-agent', 'Use a random user agent')                                       { |o| OPTIONS[:agent]   = o }
end.parse!

#
# File formatting
#
def format_file
  FORMAT.info('Writing to temporary file..')
  if File.exists?(OPTIONS[:file])
    file = Tempfile.new('file') # Write to a temp file
    IO.read(OPTIONS[:file]).each_line do |line|
      File.open(file, 'a+') { |format| format.puts(line) unless line.chomp.empty? }
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
  query = SEARCH_QUERY

  File.read("#{PATH}/log/query_blacklist").each_line do |black|  # check if the search query is black listed
    if query == black
      query = File.readlines("#{PATH}/lib/lists/search_query.txt").sample  # Retry if it is
    end
  end

  FORMAT.info("I'm searching for possible SQL vulnerable sites, using search query #{query.chomp}")
  agent = Mechanize.new
  if OPTIONS[:proxy]
    agent.set_proxy(OPTIONS[:proxy].split(":").first, OPTIONS[:proxy].split(":").last)  # Set your proxy if used
  end
  if OPTIONS[:agent]
    agent.user_agent = USER_AGENTS["rand_agents"][rand(1..55)]  # Grab a random user agent from the YAML file
  else
    agent.user_agent = DEFAULT_USER_AGENT  # Default user agent
  end
  page = agent.get('http://www.google.com/')
  google_form = page.form('f')
  google_form.q = "#{query}"  # Search Google for te query
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
        MULTIPARAMS.check_for_multiple_parameters(urls_to_log, sql)
        File.open("#{PATH}/tmp/SQL_sites_to_check.txt", 'a+') { |to_check| to_check.puts("#{urls_to_log}#{sql}") } # Add sql syntax to all "="
      }
    end
  end
  FORMAT.info("I've dumped possible vulnerable sites into #{PATH}/tmp/SQL_sites_to_check.txt")
end

#
# Check the sites that where found for vulnerabilities by checking if they throw a certain error
#
def vulnerability_check
  OPTIONS[:default] ? file_to_read = "tmp/SQL_sites_to_check.txt" : file_to_read = "tmp/#sites.txt"
  FORMAT.info('Forcing encoding to UTF-8') unless OPTIONS[:file]
  IO.read("#{PATH}/#{file_to_read}").each_line do |vuln|
    begin
      FORMAT.info("Parsing page for SQL syntax error: #{vuln.chomp}")
      Timeout::timeout(10) do
        vulns = vuln.encode(Encoding.find('UTF-8'), {invalid: :replace, undef: :replace, replace: ''}) # Force encoding to UTF-8
        begin
          if SETTINGS.parse("#{vulns.chomp}'", 'html', 0) =~ SQL_VULN_REGEX  # If it has the vuln regex error
            FORMAT.site_found(vulns.chomp)
            File.open("#{PATH}/tmp/SQL_VULN.txt", "a+") { |vulnerable| vulnerable.puts(vulns) }
            sleep(0.5)
          else
            FORMAT.warning("URL: #{vulns.chomp} is not vulnerable, dumped to non_exploitable.txt")
            File.open("#{PATH}/log/non_exploitable.txt", "a+") { |non_exploit| non_exploit.puts(vulns) }
            sleep(0.5)
          end
        rescue Timeout::Error, OpenSSL::SSL::SSLError  # Timeout or SSL errors
          FORMAT.warning("URL: #{vulns.chomp} failed to load dumped to non_exploitable.txt")
          File.open("#{PATH}/log/non_exploitable.txt", "a+") { |timeout| timeout.puts(vulns) }
          sleep(0.5)
          next
        end
      end
    rescue *LOADING_ERRORS
      FORMAT.err("URL: #{vuln.chomp} failed due to an error while connecting, URL dumped to non_exploitable.txt")
      File.open("#{PATH}/log/non_exploitable.txt", "a+") { |error| error.puts(vuln) }
      next
    end
  end
end

#
# This case statement has to be empty or the program won't read the options constants
#
case
  when OPTIONS[:default]
    begin
      Whitewidow::Misc.new.spider unless OPTIONS[:banner]
      sleep(1)
      if OPTIONS[:credits]
        Credits.credits
        sleep(1)
      end
      if OPTIONS[:legal]
        Legal::Legal.new.legal
      end
      get_urls
      if File.size("#{PATH}/tmp/SQL_sites_to_check.txt") == 0
        FORMAT.warning("No sites found for search query: #{SEARCH_QUERY}. Adding query to blacklist so it won't be run again.")  # Add the query to the blacklist
        File.open("#{PATH}/log/query_blacklist", "a+") { |query| query.puts(SEARCH_QUERY) }
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
      File.open("#{PATH}/log/error_log.LOG", 'a+') {
          |s| s.puts("No sites found with search query #{SEARCH_QUERY}")
      } if File.size("#{PATH}/tmp/SQL_sites_to_check.txt") == 0
      File.truncate("#{PATH}/tmp/SQL_sites_to_check.txt", 0)
      FORMAT.info("I'm truncating SQL_sites_to_check file back to #{File.size("#{PATH}/tmp/SQL_sites_to_check.txt")}")
      Copy.file("#{PATH}/tmp/SQL_VULN.txt", "#{PATH}/log/SQL_VULN.LOG")
      File.truncate("#{PATH}/tmp/SQL_VULN.txt", 0)
      FORMAT.info("I've run all my tests and queries, and logged all important information into #{PATH}/log/SQL_VULN.LOG")
    rescue *FATAL_ERRORS => e
      d = DateTime.now
      FORMAT.fatal("I've experienced an error and won't continue.. It's gonna break something if I keep trying.. Error: #{e}")
      File.open("#{PATH}/log/error_log.LOG", 'a+') {
          |error| error.puts("[#{d.month}-#{d.day}-#{d.year} :: #{Time.now.strftime("%T")}]#{e}")
      }
      FORMAT.info("I'll log the error inside of #{PATH}/log/error_log.LOG for further analysis.")
    end
  when OPTIONS[:file]
    begin
      Whitewidow::Misc.new.spider unless OPTIONS[:banner]
      sleep(1)
      if OPTIONS[:credits]
        Credits.credits
        sleep(1)
      end
      if OPTIONS[:legal]
        Legal::Legal.new.legal
      end
      if OPTIONS[:legal]
        Legal::Legal.new.legal
      end
      FORMAT.info('Formatting file')
      format_file
      vulnerability_check
      File.truncate("#{PATH}/tmp/SQL_sites_to_check.txt", 0)
      FORMAT.info("I'm truncating SQL_sites_to_check file back to #{File.size("#{PATH}/tmp/SQL_sites_to_check.txt")}")
      Copy.file("#{PATH}/tmp/SQL_VULN.txt", "#{PATH}/log/SQL_VULN.LOG")
      File.truncate("#{PATH}/tmp/SQL_VULN.txt", 0)
      FORMAT.info(
          "I've run all my tests and queries, and logged all important information into #{PATH}/log/SQL_VULN.LOG"
      ) unless File.size("#{PATH}/log/SQL_VULN.LOG") == 0
    rescue *FATAL_ERRORS => e
      d = DateTime.now
      FORMAT.fatal("I've experienced an error and won't continue.. It's gonna break something if I keep trying.. Error: #{e}")
      File.open("#{PATH}/log/error_log.LOG", 'a+') {
          |error| error.puts("[#{d.month}-#{d.day}-#{d.year}::#{Time.now.strftime("%T")}] Error: #{e}")
      }
      FORMAT.info("I'll log the error inside of #{PATH}/log/error_log.LOG for further analysis.")
    end
  when OPTIONS[:legal]
    Legal::Legal.new.legal
  when OPTIONS[:run]
    OPTIONS[:run].times do
      system('ruby whitewidow.rb -d --dry-run --batch --banner')
    end
    FORMAT.info("#{OPTIONS[:run]} runs completed successfully.")
  when OPTIONS[:spider]
    begin
      arr = SPIDER_BOT.pull_links(OPTIONS[:spider])
      SPIDER_BOT.follow_links(arr)
      FORMAT.info("Found a total of #{File.open("tmp/blackwidow_log.txt").readlines.size} links. Running them as file..")
      system("ruby whitewidow.rb --banner -f tmp/blackwidow_log.txt")
      File.truncate("tmp/blackwidow_log.txt", 0)
    rescue *SPIDER_ERRORS
      FORMAT.err("#{OPTIONS.spider} encountered an error, skipping..")
    end
  else
    FORMAT.warning('You failed to pass me a flag!')
    usage_page
end
