#!/usr/local/env ruby
require_relative 'lib/imports/constants_and_requires'

#
# Options banner
#
def banner_message
  [
    "USAGE: ruby whitewidow.rb -[SHORT-OPTS] [ARGS] --[LONG-OPTS] [ARGS]".cyan.bold,
    "Mandatory options  : -[d|f|s] FILE|URL --[default|file|spider] FILE|URL".cyan.bold,
    "Enumeration options: -[x] NUM --[dry-run|batch|run-x] NUM".cyan.bold,
    "Anomity options    : -[p] IP:PORT --[rand-agent|proxy] IP:PORT".cyan.bold,
    "Processing options : -[D|c] DORK|NAME --[sqlmap|dork|column] DORK|NAME".cyan.bold,
    "Misc options       : -[l|b|u] --[legal|banner|beep|update]".cyan.bold,
    "Dev options        : --[test]".cyan.bold,
    " " # Blank line for nice formatting
  ].join("\n")
end

#
# Usage page, basic help page for commands
#
def usage_page
  FORMAT.info("Check the README.md file for a list of flags and further information or go here: #{FUNCTION_PAGE_LINK}\n")
end

#
# Append into the OPTIONS constant so that we can call the flag from the constant instead of a class
#
ARGV << '-h' if ARGV.empty? # Display help dialog if no flags are passed
OptionParser.new do |opt|
  opt.banner = banner_message
  opt.on('-f FILE', '--file FILE', 'Pass a filename to scan for vulnerabilities')         { |o| OPTIONS[:file]    = o }
  opt.on('-s URL', '--spider URL', 'Spider a web page and save all the URLS')             { |o| OPTIONS[:spider]  = o }
  opt.on('-p IP:PORT', '--proxy IP:PORT', 'Configure to run with a proxy, must use ":"')  { |o| OPTIONS[:proxy]   = o }
  opt.on('-x NUM', '--run-x NUM', 'Run the specified amount of dry runs')                 { |o| OPTIONS[:run]     = o }
  opt.on('-D DORK', '--dork DORK', 'Use your own dork to do the searching')               { |o| OPTIONS[:dork]    = o } # Issue #32 https://github.com/Ekultek/whitewidow/issues/32
  opt.on('-c NAME', '--column NAME', 'Specify a column name to be run for union SQLi')    { |o| OPTIONS[:cols]    = o }
  opt.on('-d', '--default', 'Run in default mode, scrape Google')                         { |o| OPTIONS[:default] = o }
  opt.on('-l', '--legal', 'Show the legal information and the TOS')                       { |o| OPTIONS[:legal]   = o }
  opt.on('-b', '--banner', 'Hide the banner')                                             { |o| OPTIONS[:banner]  = o }
  opt.on('-v', '--version', 'Display the version number and exit')                        { |o| OPTIONS[:version] = o }
  opt.on('-u', '--update', 'Update whitewidow with the newest version')                   { |o| OPTIONS[:update]  = o }
  opt.on('--dry-run', 'Run a dry run (no checking for vulnerability with prompt)')        { |o| OPTIONS[:dry]     = o }
  opt.on('--batch', 'No prompts, used in conjunction with the dry run')                   { |o| OPTIONS[:batch]   = o }
  opt.on('--beep', 'Make a beep when the program finds a vulnerability')                  { |o| OPTIONS[:beep]    = o }
  opt.on('--rand-agent', 'Use a random user agent')                                       { |o| OPTIONS[:agent]   = o }
  opt.on('--sqlmap', 'Run sqlmap through the SQL_VULN.LOG file as a bulk file')           { |o| OPTIONS[:sqlmap]  = o }
  opt.on('--test', 'Used mostly for development use')                                     { |o| OPTIONS[:test]    = o }
  opt.on('-h', '--help', 'Display this help dialog and exit') do
    usage_page
    puts opt
  end
end.parse!

# This case statement has to be empty or the program won't read the options constants
begin
  case
  when OPTIONS[:default]
    begin
      SETTINGS.hide_banner?
      SETTINGS.show_legal?
      Whitewidow::Scanner.get_urls(OPTIONS[:proxy])
      #SETTINGS.black_list_query(OPTIONS[:dork] == nil ? DEFAULT_SEARCH_QUERY : OPTIONS[:dork],
                                #IO.read(SITES_TO_CHECK_PATH).size)
      if File.size("#{SITES_TO_CHECK_PATH}") == 0  # Saving just in case
        FORMAT.warning("No sites found for search query: #{SEARCH_QUERY}. Adding query to blacklist so it won't be run again.")  # Add the query to the blacklist #  File.open("#{QUERY_BLACKLIST_PATH}", "a+") { |query| query.puts(SEARCH_QUERY) }
        FORMAT.info("Query added to blacklist and will not be run again, exiting..")
        exit(1)
      elsif OPTIONS[:dry]
      #if OPTIONS[:dry]
        dry = FORMAT.prompt('Run the sites[Y/N]') unless OPTIONS[:batch]
        dry = 'N' if OPTIONS[:batch]
        if dry.upcase == 'N'
          FORMAT.info('Sites saved to file, will not run scan now..')
          exit(0)
        else
          Whitewidow::Scanner.vulnerability_check(file_mode: false)
        end
      else
        Whitewidow::Scanner.vulnerability_check(file_mode: false)
      end
      File.open("#{ERROR_LOG_PATH}", 'a+') {
          |s| s.puts("No sites found with search query #{DEFAULT_SEARCH_QUERY}")
      } if File.size("#{SITES_TO_CHECK_PATH}") == 0
      File.truncate("#{SITES_TO_CHECK_PATH}", 0)
      FORMAT.info("I'm truncating SQL_sites_to_check file back to #{File.size("#{SITES_TO_CHECK_PATH}")}")
      FileUtils.copy(TEMP_VULN_LOG, SQL_VULN_SITES_LOG)
      File.truncate("#{TEMP_VULN_LOG}", 0)
      FORMAT.info("I've run all my tests and queries, and logged all important information into #{SQL_VULN_SITES_LOG}")
    rescue *FATAL_ERRORS => e
      File.open(ERROR_LOG_PATH, 'a+') { |error| error.puts("#{Date.today}\n#{e.backtrace}\n---") }
      FORMAT.fatal("Issue template has been generated for this error, create a new issue named: #{SETTINGS.random_issue_name} #{e}")
      FORMAT.info("An issue template has been generated for you and is located in #{ISSUE_TEMPLATE_PATH}")
      SETTINGS.create_issue_page("Getting error: #{e}", e, "Run with #{OPTIONS}",
                                 OPTIONS[:dork] == nil ? DEFAULT_SEARCH_QUERY : OPTIONS[:dork])
    end
  when OPTIONS[:file]
    begin
      SETTINGS.hide_banner?
      SETTINGS.show_legal?
      FORMAT.info('Formatting file')
      Whitewidow::Scanner.format_file(OPTIONS[:file])
      Whitewidow::Scanner.vulnerability_check(file_mode: true)
      File.truncate("#{SITES_TO_CHECK_PATH}", 0)
      FORMAT.info("I'm truncating SQL_sites_to_check file back to #{File.size("#{SITES_TO_CHECK_PATH}")}")
      FileUtils.copy(TEMP_VULN_LOG, SQL_VULN_SITES_LOG)
      File.truncate("#{TEMP_VULN_LOG}", 0)
      FORMAT.info(
          "I've run all my tests and queries, and logged all important information into #{SQL_VULN_SITES_LOG}"
      ) unless File.size("#{SQL_VULN_SITES_LOG}") == 0
    rescue *FATAL_ERRORS => e
      File.open(ERROR_LOG_PATH, 'a+') { |error| error.puts("#{Date.today}\n#{e.backtrace}\n---") }
      FORMAT.fatal("Issue template has been generated for this error, create a new issue named: #{SETTINGS.random_issue_name} #{e}")
      FORMAT.info("An issue template has been generated for you and is located in #{ISSUE_TEMPLATE_PATH}")
      SETTINGS.create_issue_page("Getting error: #{e}", e, "Run with #{OPTIONS}",
                                 OPTIONS[:dork] == nil ? DEFAULT_SEARCH_QUERY : OPTIONS[:dork])
    end
  when OPTIONS[:legal]
    SETTINGS.show_legal?
  when OPTIONS[:run]
    OPTIONS[:run].to_i.times do
      system('ruby whitewidow.rb -d --dry-run --batch --banner')
    end
    FORMAT.info("#{OPTIONS[:run]} runs completed successfully.")
  when OPTIONS[:sqlmap]
    SETTINGS.sqlmap_config
    FORMAT.info("Launching sqlmap..")
    commands = IO.read(SQLMAP_CONFIG_PATH)
    system(commands.chomp)
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
  when OPTIONS[:update]
    FORMAT.info("Updating to newest version..")
    SETTINGS.update!
  when OPTIONS[:test]
    system('rspec')
  else
    exit(1)
  end
rescue => e
  FORMAT.err("Failed with error code #{e}")
  if e.inspect =~ /OpenSSL::SSL::SSLError/
    FORMAT.warning("Your user agent is bad, make an issue with the user agent")
    FORMAT.info("Trying again with a different user agent")  # Temp fix until I can fix the user agents.
    begin
      system("ruby whitewidow.rb -d --banner --rand-agent")
    rescue OpenSSL::SSL::SSLError
      FORMAT.fatal("User agent failed to load, running as default..")
      system("ruby whitewidow.rb -d --banner")
    end
  elsif e.inspect =~ /tIDENTIFIER/
    FORMAT.fatal("What we have here is a P.I.C.N.I.C. To run this program you need a Ruby version >=2.3.0.")
    FORMAT.fatal("Your current ruby version: #{RUBY_VERSION}")
    FORMAT.fatal("Download the latest Ruby by#{SETTINGS.ruby_download_link}")
    exit(1)
  else
    FORMAT.fatal("Program failed with error code: #{e}, error saved to error_log.txt")
    File.open(ERROR_LOG_PATH, 'a+') { |error| error.puts("#{Date.today}\n#{e.backtrace}\n---") }
    FORMAT.fatal("Issue template has been generated for this error, create a new issue named: #{SETTINGS.random_issue_name} #{e}")
    FORMAT.info("An issue template has been generated for you and is located in #{ISSUE_TEMPLATE_PATH}")
    SETTINGS.create_issue_page("Getting error: #{e}", e, "Run with #{OPTIONS}",
                               OPTIONS[:dork] == nil ? DEFAULT_SEARCH_QUERY : OPTIONS[:dork])
  end
rescue Interrupt
  FORMAT.err("User aborted scanning.")
  exit(1)
end
