#!/usr/local/env ruby

# I like how I wrote all these comments and completely failed to comment my own code, what the hell was I thinking?
# Then again this was like my first ever program so... I'll make it that much better

require_relative 'lib/imports/constants_and_requires'

#
# Usage page, shows basic shell of commands
#
def usage_page
  FORMAT.info("You can run me with the following flags: #{File.basename(__FILE__)} -[d|e|h] -[f] <path/to/file/if/any>")
  exit
end

#
# Append into the OPTIONS constant so that we can call the information from there
#
OptionParser.new do |opt|
  opt.on('-f FILE', '--file FILE', 'Pass a filename to scan') { |o| OPTIONS[:file] = o }
  opt.on('-d', '--default', "Run me in default mode, I'll scrape Google") { |o| OPTIONS[:default] = o }
  opt.on('-l', '--legal', 'Show the legal information and the TOS') { |o| OPTIONS[:legal] = o }
  opt.on('-c', '--credits', 'Show the credits to the creator') { |o| OPTIONS[:credits] = o }
  opt.on('--banner', 'Run without displaying the banner') { |o| OPTIONS[:banner] = o }
  opt.on('--proxy IP:PORT', 'Configure to run with a proxy, must use ":"') { |o| OPTIONS[:proxy] = o }
  opt.on('--batch', 'No prompts, used in conjunction with the dry run') { |o| OPTIONS[:batch] = o }
  opt.on('--dry-run', 'Save the sites to the SQL_sites_to_check file only, no checking.') { |o| OPTIONS[:dry] = o }
end.parse!

#
# Method for Nokogiri so I don't have to continually type Nokogiri::HTML
#
# @param [String] site
def page(site)
  Nokogiri::HTML(RestClient.get(site))
end

#
# This is actually pretty smart, it's used to parse the HTML
#
# @param [String] site
# @param [String] tag
# @param [Integer] i
def parse(site, tag, i)
  parsing = page(site)
  parsing.css(tag)[i].to_s
end

#
# File formatting
#
def format_file
  FORMAT.info('Writing to temporary file..')
  if File.exists?(OPTIONS[:file])
    file = Tempfile.new('file')
    IO.read(OPTIONS[:file]).each_line do |s|
      File.open(file, 'a+') { |format| format.puts(s) unless s.chomp.empty? }
    end
    IO.read(file).each_line do |file|
      File.open("#{PATH}/tmp/#sites.txt", 'a+') { |line| line.puts(file) }
    end
    file.unlink
    FORMAT.info("File: #{OPTIONS[:file]}, has been formatted and saved as #sites.txt in the tmp directory.")
  else
    puts <<-_END_

             Hey now my friend, I know you're eager, I am also, but that file #{OPTIONS[:file]}
             either doesn't exist, or it's not in the directory you say it's in..

             I'm gonna need you to go find that file, move it to the correct directory and then
             run me again.

             Don't worry I'll wait!
    _END_
    .yellow.bold
  end
end

#
# Get the URLS by connecting to google and scraping for the URLS on the first page
#
def get_urls
  query = SEARCH

  File.read("#{PATH}/log/query_blacklist").each_line do |blacked| # Check if the query is blacklisted or not
    if query == blacked
      query = File.readlines("#{PATH}/lib/lists/search_query.txt").sample # If it is, change it.
    end
  end

  FORMAT.info("I'll run in default mode!")
  FORMAT.info("I'm searching for possible SQL vulnerable sites, using search query #{SEARCH}")
  agent = Mechanize.new
  if OPTIONS[:proxy]
    agent.set_proxy(OPTIONS[:proxy].split(":").first, OPTIONS[:proxy].split(":").last)
  end
  agent.user_agent = USER_AGENT
  page = agent.get('http://www.google.com/')
  google_form = page.form('f')
  google_form.q = "#{query}"
  url = agent.submit(google_form, google_form.buttons.first)
  url.links.each do |link|
    if link.href.to_s =~ /url.q/
      str = link.href.to_s
      str_list = str.split(%r{=|&})
      urls = str_list[1]
      next if urls.split("/")[2].start_with? *SKIP # Skip all the bad URLs
      urls_to_log = URI.decode(urls)
      FORMAT.success("Site found: #{urls_to_log}")
      sleep(0.5)
      %w(' ` -- ;).each { |sql|
        MULTIPARAMS.check_for_multiple_parameters(urls_to_log, sql)
        File.open("#{PATH}/tmp/SQL_sites_to_check.txt", 'a+') { |s| s.puts("#{urls_to_log}#{sql}") } # Add sql syntax to all "="
      }
    end
  end
  FORMAT.info("I've dumped possible vulnerable sites into #{PATH}/tmp/SQL_sites_to_check.txt")
end

#
# Check the sites that where found for vulnerabilities by checking if they throw a certain error
#
def vulnerability_check
  case # A case statement without an else
  when OPTIONS[:default]
    FORMAT.info("Running in default mode..")
    file_to_read = "tmp/SQL_sites_to_check.txt"
  when OPTIONS[:file]
    FORMAT.info("Running in file mode..")
    file_to_read = "tmp/#sites.txt"
  end
  FORMAT.info('Forcing encoding to UTF-8') unless OPTIONS[:file]
  IO.read("#{PATH}/#{file_to_read}").each_line do |vuln|
    begin
      FORMAT.info("Parsing page for SQL syntax error: #{vuln.chomp}")
      Timeout::timeout(10) do
        vulns = vuln.encode(Encoding.find('UTF-8'), {invalid: :replace, undef: :replace, replace: ''}) # Force encoding to UTF-8
        begin
          if parse("#{vulns.chomp}'", 'html', 0)[/You have an error in your SQL syntax/]
            FORMAT.site_found(vulns.chomp)
            File.open("#{PATH}/tmp/SQL_VULN.txt", "a+") { |s| s.puts(vulns) }
            sleep(1)
          else
            FORMAT.warning("URL: #{vulns.chomp} is not vulnerable, dumped to non_exploitable.txt")
            File.open("#{PATH}/log/non_exploitable.txt", "a+") { |s| s.puts(vulns) }
            sleep(1)
          end
        rescue Timeout::Error, OpenSSL::SSL::SSLError
          FORMAT.warning("URL: #{vulns.chomp} failed to load dumped to non_exploitable.txt")
          File.open("#{PATH}/log/non_exploitable.txt", "a+") { |s| s.puts(vulns) }
          sleep(1)
          next
        end
      end
    rescue *LOADING_ERRORS
      FORMAT.err("URL: #{vuln.chomp} failed due to an error while connecting, URL dumped to non_exploitable.txt")
      File.open("#{PATH}/log/non_exploitable.txt", "a+") { |s| s.puts(vuln) }
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
        FORMAT.warning("No sites found for search query: #{SEARCH}. Adding query to blacklist so it won't be run again.")
        File.open("#{PATH}/log/query_blacklist", "a+"){ |query| query.puts(SEARCH) }
        FORMAT.info("Query added to blacklist and will not be run again, exiting..")
        exit(1)
      elsif OPTIONS[:dry]
        dry = FORMAT.prompt('Run the sites[Y/N]') unless OPTIONS[:batch]
        dry = 'N' if OPTIONS[:batch]
        if dry.upcase == 'N'
          FORMAT.info('Sites saved to file, will not run scan now..')
          exit(1)
        else
          vulnerability_check
        end

      else
        vulnerability_check
      end
      File.open("#{PATH}/log/error_log.LOG", 'a+') {
          |s| s.puts("No sites found with search query #{SEARCH}")
      } if File.size("#{PATH}/tmp/SQL_sites_to_check.txt") == 0
      File.truncate("#{PATH}/tmp/SQL_sites_to_check.txt", 0)
      FORMAT.info("I'm truncating SQL_sites_to_check file back to #{File.size("#{PATH}/tmp/SQL_sites_to_check.txt")}")
      Copy.file("#{PATH}/tmp/SQL_VULN.txt", "#{PATH}/log/SQL_VULN.LOG")
      File.truncate("#{PATH}/tmp/SQL_VULN.txt", 0)
      FORMAT.info("I've run all my tests and queries, and logged all important information into #{PATH}/log/SQL_VULN.LOG")
      FORMAT.info("I've found #{@vuln_foundl} possible vulnerabilities.")
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
          |error| error.puts("[#{d.month}-#{d.day}-#{d.year} :: #{Time.now.strftime("%T")}]#{e}")
      }
      FORMAT.info("I'll log the error inside of #{PATH}/log/error_log.LOG for further analysis.")
    end
  when OPTIONS[:legal]
    Legal::Legal.new.legal
  when OPTIONS[:credits]
    Credits.credits
  else
    FORMAT.warning('You failed to pass me a flag!')
    usage_page
end