require 'mechanize'
require 'nokogiri'
require 'restclient'
require 'timeout'
require 'uri'
require 'fileutils'
require 'colored'
require 'yaml'
require 'date'
require_relative 'lib/format.rb'
require_relative 'lib/credits.rb'
require_relative 'lib/legal.rb'

include Format
include Credits
include Legal


PATH = Dir.pwd
VERSION = File.read("#{PATH}/lib/ruby-version.rb")
SEARCH = File.readlines("#{PATH}/lib/search_query.txt").sample
info = YAML.load_file("#{PATH}/lib/rand-agents.yaml")
@user_agent = info['user_agents'][info.keys.sample]


def page(site)
  Nokogiri::HTML(RestClient.get(site))
end

def parse(site, tag, i)
  parsing = page(site)
  parsing.css(tag)[i].to_s
end

def pull_proxy
  info = parse("http://www.nntime.com/",'.odd', 1)
  @ip = info[/\D\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\D/].gsub(">", "").gsub("<", "")
  @port = info[/8080/] || info[/3128/] || info[/80/] || info[/3129/] || info[/6129/]
  proxy = "#{@ip}:#{@port}"
  Format.info("Proxy discovered: #{proxy}")
end

def get_urls
  Format.info("Searching for possible SQL vulnerable sites, using search query #{SEARCH}")
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
        #skipping if 'webcache.googleusercontent.com' || 'duckfm.net' || 'search.clearch.org' || 'search1.speedbit.com' || 'yoursearch.me' || 'search.speedbit.com' || 'www.sa-k.net' || 'github.com' || 'stackoverflow.com'
        next if str_list[1].split('/')[2] == 'webcache.googleusercontent.com'
        next if str_list[1].split('/')[2] == 'search.clearch.org'
        next if str_list[1].split('/')[2] == 'duckfm.net'
        next if str_list[1].split('/')[2] == 'search1.speedbit.com'
        next if str_list[1].split('/')[2] == 'yoursearch.me'
        next if str_list[1].split('/')[2] == 'search.speedbit.com'
        next if str_list[1].split('/')[5] == 'preferences?hl=en'
        next if str_list[1].split('/')[2] == 'www.sa-k.net'
        next if str_list[1].split('/')[2] == 'github.com'
        next if str_list[1].split('/')[2] == 'stackoverflow.com'
        urls_to_log = URI.decode(urls)
        Format.success("Site found: #{urls_to_log}")
        sleep(1)
        File.open("#{PATH}/tmp/SQL_sites_to_check.txt", 'a+') { |s| s.puts("#{urls_to_log}'") }
      end
    end
  Format.info("Possible vulnerable sites dumped into #{PATH}/tmp/SQL_sites_to_check.txt")
end

def begin_vulnerability_check
  Format.info("Checking if sites are vulnerable.")
  IO.read("#{PATH}/tmp/SQL_sites_to_check.txt").each_line do |parse|
    begin
      Format.info("Parsing page for SQL syntax error: #{parse.chomp}")
   	  Timeout::timeout(10) do
	    begin
	      if parse("#{parse.chomp}", 'html', 0)[/You have an error in your SQL syntax/]
          Format.success("URL: #{parse.chomp} returned SQL syntax error, temporarily dumped to SQL_VULN.txt")
	        File.open("#{PATH}/tmp/SQL_VULN.txt", "a+") { |s| s.puts(parse) }
          sleep(1)
	      else
	        Format.warning("URL: #{parse.chomp} is not vulnerable, dumped to non_exploitable.txt")
          File.open("#{PATH}/log/non_exploitable.txt", "a+") { |s| s.puts(parse) }
          sleep(1)
	      end
	    rescue Timeout::Error, OpenSSL::SSL::SSLError
	      Format.info("URL: #{parse.chomp} failed to load dumped to non_exploitable.txt")
        File.open("#{PATH}/log/non_exploitable.txt", "a+") { |s| s.puts(parse) }
	  	  next
	      sleep(1)
        end
	    end
    rescue RestClient::ResourceNotFound, RestClient::InternalServerError, RestClient::RequestTimeout, RestClient::Gone, RestClient::SSLCertificateNotVerified, RestClient::Forbidden, OpenSSL::SSL::SSLError, Errno::ECONNREFUSED, URI::InvalidURIError, Errno::ECONNRESET, Timeout::Error, OpenSSL::SSL::SSLError, ArgumentError, RestClient::MultipleChoices => e
        Format.err("URL: #{parse.chomp} failed due to an error while connecting, URL dumped to non_exploitable.txt")
        File.open("#{PATH}/log/non_exploitable.txt", "a+") { |s| s.puts(parse) }
        next
      end
    end
  end

def show_vuln_site
  Format.info('Whitewidow discovered the following sites with SQL syntax errors:')
  puts
  IO.read("#{PATH}/tmp/SQL_VULN.txt").each_line do |vuln|
    info("#{vuln.chomp}")
	  sleep(1)
  end
  puts
end

begin
  puts IO.read("#{PATH}/lib/spider.txt")
  sleep(1)
  Credits.credits
  sleep(1)
  Legal.legal
  get_urls
  if SEARCH.nil?
    puts "\nYou must enter search queries into #{PATH}/lib/search_query.txt\n".white.bold
    exit
  end
  begin_vulnerability_check
  show_vuln_site unless File.size("#{PATH}/tmp/SQL_VULN.txt") == 0
  File.truncate("#{PATH}/tmp/SQL_sites_to_check.txt", 0)
  Format.info("Truncating SQL_sites_to_check file back to #{File.size("#{PATH}/tmp/SQL_sites_to_check.txt")}")
  File.open("#{PATH}/tmp/SQL_VULN.txt", "a+").each_line do |s|
    File.open("#{PATH}/log/SQL_VULN.LOG", "a+") { |vul| vul.puts(s) }
  end
  File.truncate("#{PATH}/tmp/SQL_VULN.txt", 0)
  Format.info("All tests have been queried and run, all logged data will be in #{PATH}/log/SQL_VULN.LOG") unless File.size("#{PATH}/log/SQL_VULN.LOG") == 0
rescue Mechanize::ResponseCodeError, RestClient::ServiceUnavailable, OpenSSL::SSL::SSLError, RestClient::BadGateway => e
  t = Time.now
  d = DateTime.now
  Format.fatal("Program stopped due to encountering error #{e}. You can try to change your IP and resume searching.")
  File.open("#{PATH}/log/error_log.LOG", 'a+'){ |error| error.puts("[#{d.month}-#{d.day}-#{d.year} :: #{t.hour}:#{t.min}:#{t.sec}]#{e}") }
  Format.info("Error has been logged inside of #{PATH}/log/error_log.LOG")
end

