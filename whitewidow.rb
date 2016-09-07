#!/usr/local/env ruby

# I like how I wrote all these comments and completely failed to comment my own code, what the hell was I thinking?
# Then again this was like my first ever program so... I'll make it that much better

require_relative 'lib/imports/constants_and_requires'

#
# Usage page, shows basic shell of commands
#
def usage_page
  Format.usage("You can run me with the following flags: #{File.basename(__FILE__)} -[d|e|h] -[f] <path/to/file/if/any>")
  exit
end

#
# Examples page, gives info on how to use the program
#
def examples_page
  Format.usage('This is my examples page, I\'ll show you a few examples of how to get me to do what you want.')
  Format.usage('Running me with a file: whitewidow.rb -f <path/to/file> keep the file inside of one of my directories.')
  Format.usage('Running me default, if you don\'t want to use a file, because you don\'t think I can handle it, or for whatever reason, you can run me default by passing the Default flag: whitewidow.rb -d this will allow me to scrape Google for some SQL vuln sites, no guarentees though!')
  Format.usage('Running me with my Help flag will show you all options an explanation of what they do and how to use them')
  Format.usage('Running me without a flag will show you the usage page. Not descriptive at all but gets the point across')
end

#
# Append into the OPTIONS constant so that we can call the information from there
#
OptionParser.new do |opt|
  opt.on('-f FILE', '--file FILE', "Pass me a file name") { |o| OPTIONS[:file] = o }
  opt.on('-d', '--default', "Run me in default mode, I'll scrape Google") { |o| OPTIONS[:default] = o }
  opt.on('-e', '--example', "Show examples page") { |o| OPTIONS[:example] = o }
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
  Format.info('Writing to temporary file..')
  if File.exists?(OPTIONS[:file])
    file = Tempfile.new('file')
    IO.read(OPTIONS[:file]).each_line do |s|
      File.open(file, 'a+') { |format| format.puts(s) unless s.chomp.empty? }
    end
    IO.read(file).each_line do |file|
      File.open("#{PATH}/tmp/#sites.txt", 'a+') { |line| line.puts(file) }
    end
    file.unlink
    Format.info("File: #{OPTIONS[:file]}, has been formatted and saved as #sites.txt in the tmp directory.")
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
  Format.info("I'll run in default mode!")
  Format.info("I'm searching for possible SQL vulnerable sites, using search query #{SEARCH}")
  agent = Mechanize.new
  agent.user_agent = @user_agent
  page = agent.get('http://www.google.com/')
  google_form = page.form('f')
  google_form.q = "#{SEARCH}"
  url = agent.submit(google_form, google_form.buttons.first)
  url.links.each do |link|
    if link.href.to_s =~ /url.q/
      str = link.href.to_s
      str_list = str.split(%r{=|&})
      urls = str_list[1]
      #next if urls.split('/')[2].start_with? 'stackoverflow.com', 'github.com', 'www.sa-k.net', 'yoursearch.me', 'search1.speedbit.com', 'duckfm.net', 'search.clearch.org', 'webcache.googleusercontent.com'
      #next if urls.start_with?('settings/ads/preferences?hl=en') #<= ADD HERE REMEMBER A COMMA => # This doesn't work.
      urls_to_log = URI.decode(urls)
      Format.success("Site found: #{urls_to_log}")
      sleep(1)
      %w(' ` -- ;).each { |sql|
        File.open("#{PATH}/tmp/SQL_sites_to_check.txt", 'a+') { |s| s.puts("#{urls_to_log}#{sql}") }
      }
    end
  end
  Format.info("I've dumped possible vulnerable sites into #{PATH}/tmp/SQL_sites_to_check.txt")
end

#
# Check the sites that where found for vulnerabilities by checking if they throw a certain error
#
def vulnerability_check
  case # A case statement without an else
  when OPTIONS[:default]
    file_to_read = "tmp/SQL_sites_to_check.txt"
  when OPTIONS[:file]
    Format.info("Let's check out this file real quick like..")
    file_to_read = "tmp/#sites.txt"
  end
  Format.info('Forcing encoding to UTF-8') unless OPTIONS[:file]
  IO.read("#{PATH}/#{file_to_read}").each_line do |vuln|
    begin
      Format.info("Parsing page for SQL syntax error: #{vuln.chomp}")
      Timeout::timeout(10) do
        vulns = vuln.encode(Encoding.find('UTF-8'), {invalid: :replace, undef: :replace, replace: ''}) # Force encoding to UTF-8
        begin
          if parse("#{vulns.chomp}'", 'html', 0)[/You have an error in your SQL syntax/] # IS this really what I'm relying on?
            Format.site_found(vulns.chomp)
            File.open("#{PATH}/tmp/SQL_VULN.txt", "a+") { |s| s.puts(vulns) }
            sleep(1)
          else
            Format.warning("URL: #{vulns.chomp} is not vulnerable, dumped to non_exploitable.txt")
            File.open("#{PATH}/log/non_exploitable.txt", "a+") { |s| s.puts(vulns) }
            sleep(1)
          end
        rescue Timeout::Error, OpenSSL::SSL::SSLError
          Format.warning("URL: #{vulns.chomp} failed to load dumped to non_exploitable.txt")
          File.open("#{PATH}/log/non_exploitable.txt", "a+") { |s| s.puts(vulns) }
          sleep(1)
          next
        end
      end
    rescue RestClient::ResourceNotFound, RestClient::InternalServerError, RestClient::RequestTimeout, RestClient::Gone, RestClient::SSLCertificateNotVerified, RestClient::Forbidden, OpenSSL::SSL::SSLError, Errno::ECONNREFUSED, URI::InvalidURIError, Errno::ECONNRESET, Timeout::Error, OpenSSL::SSL::SSLError, Zlib::GzipFile::Error, RestClient::MultipleChoices, RestClient::Unauthorized, SocketError, RestClient::BadRequest, RestClient::ServerBrokeConnection, RestClient::MaxRedirectsReached => e
      Format.err("URL: #{vuln.chomp} failed due to an error while connecting, URL dumped to non_exploitable.txt") # I'll be putting the error also
      File.open("#{PATH}/log/non_exploitable.txt", "a+") { |s| s.puts(vuln) }
      next
    end
  end
end

#
# A case statement that is empty
#
case
  when OPTIONS[:default]
    begin
      Whitewidow.spider
      sleep(1)
      Credits.credits
      sleep(1)
      Legal.legal
      get_urls
      vulnerability_check unless File.size("#{PATH}/tmp/SQL_sites_to_check.txt") == 0
      Format.warning("No sites found for search querie: #{SEARCH}. Logging into error_log.LOG. Create a issue regarding this.") if File.size("#{PATH}/tmp/SQL_sites_to_check.txt") == 0
      File.open("#{PATH}/log/error_log.LOG", 'a+') { |s| s.puts("No sites found with search querie #{SEARCH}") } if File.size("#{PATH}/tmp/SQL_sites_to_check.txt") == 0
      File.truncate("#{PATH}/tmp/SQL_sites_to_check.txt", 0)
      Format.info("I'm truncating SQL_sites_to_check file back to #{File.size("#{PATH}/tmp/SQL_sites_to_check.txt")}")
      Copy.file("#{PATH}/tmp/SQL_VULN.txt", "#{PATH}/log/SQL_VULN.LOG")
      File.truncate("#{PATH}/tmp/SQL_VULN.txt", 0)
      Format.info("I've run all my tests and queries, and logged all important information into #{PATH}/log/SQL_VULN.LOG")
    rescue Mechanize::ResponseCodeError, RestClient::ServiceUnavailable, OpenSSL::SSL::SSLError, RestClient::BadGateway => e
      d = DateTime.now
      Format.fatal("Well this is pretty crappy.. I seem to have encountered a #{e} error. I'm gonna take the safe road and quit scanning before I break something. You can either try again, or manually delete the URL that caused the error.")
      File.open("#{PATH}/log/error_log.LOG", 'a+'){ |error| error.puts("[#{d.month}-#{d.day}-#{d.year} :: #{Time.now.strftime("%T")}]#{e}") }
      Format.info("I'll log the error inside of #{PATH}/log/error_log.LOG for further analysis.")
    end
  when OPTIONS[:file]
    begin
      Whitewidow.spider
      sleep(1)
      Credits.credits
      sleep(1)
      Legal.legal
      Format.info('Formatting file')
      format_file
      vulnerability_check
      File.truncate("#{PATH}/tmp/SQL_sites_to_check.txt", 0)
      Format.info("I'm truncating SQL_sites_to_check file back to #{File.size("#{PATH}/tmp/SQL_sites_to_check.txt")}")
      Copy.file("#{PATH}/tmp/SQL_VULN.txt", "#{PATH}/log/SQL_VULN.LOG")
      File.truncate("#{PATH}/tmp/SQL_VULN.txt", 0)
      Format.info("I've run all my tests and queries, and logged all important information into #{PATH}/log/SQL_VULN.LOG") unless File.size("#{PATH}/log/SQL_VULN.LOG") == 0
    rescue Mechanize::ResponseCodeError, RestClient::ServiceUnavailable, OpenSSL::SSL::SSLError, RestClient::BadGateway => e
      d = DateTime.now
      Format.fatal("Well this is pretty crappy.. I seem to have encountered a #{e} error. I'm gonna take the safe road and quit scanning before I break something. You can either try again, or manually delete the URL that caused the error.")
      File.open("#{PATH}/log/error_log.LOG", 'a+'){ |error| error.puts("[#{d.month}-#{d.day}-#{d.year} :: #{Time.now.strftime("%T")}]#{e}") }
      Format.info("I'll log the error inside of #{PATH}/log/error_log.LOG for further analysis.")
    end
  when OPTIONS[:example]
    examples_page
  else
    Format.warning('You failed to pass me a flag!')
    usage_page
end