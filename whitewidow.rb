#!/usr/local/ruby

##############################################################################
# Lots of things need to be required for this to work... Yes it's necessary. ###
##############################################################################

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
require_relative 'lib/spider.rb'
require_relative 'lib/copy.rb'

include Format
include Credits
include Legal
include Whitewidow
include Copy

##########################
# Set constant variables ###
##########################

args = ARGV.dup
ARG = args.shift
PATH = Dir.pwd
VERSION = Whitewidow.version
SEARCH = File.readlines("#{PATH}/lib/search_query.txt").sample
info = YAML.load_file("#{PATH}/lib/rand-agents.yaml")
@user_agent = info['user_agents'][info.keys.sample]

def usage_page
  Format.usage("You can run me with the following flags: #{File.basename(__FILE__)} -[d|f|h|hh] <path/to/file/if/any>")
  exit
end

def examples_page
  Format.usage('This is my examples page, I\'ll show you a few examples of how to get me to do what you want.')
  Format.usage('Running me with a file: whitewidow.rb -f <path/to/file> keep the file inside of one of my directories.')
  Format.usage('Running me default, if you don\'t want to use a file, because you don\'t think I can handle it, or for whatever reason, you can run me defualt by passing the Defualt flag: whitewidow.rb -d this will allow me to scrape Google for some SQL vuln sites, no guarentees though!')
  Format.usage('Running me with my Usage flag will show you the boring usage page.. Yeah it\'s not very exciting..')
end

def page(site)
  Nokogiri::HTML(RestClient.get(site))
end

###################################################################
# Parse is used to parse the HTML with Nokogiri, makes it simple. ###
###################################################################

def parse(site, tag, i)
  parsing = page(site)
  parsing.css(tag)[i].to_s
end

=begin
def pull_proxy
  info = parse("http://www.nntime.com/",'.odd', 1)
  @ip = info[/\D\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\D/].gsub(">", "").gsub("<", "")
  @port = info[/8080/] || info[/3128/] || info[/80/] || info[/3129/] || info[/6129/]  #Not ready yet
  proxy = "#{@ip}:#{@port}"
  Format.info("Proxy discovered: #{proxy}")
end
=end

######################################
# Start pulling the URLs from Google ###
######################################

def get_urls
  Format.info('I\'ll run in default mode then!')
  puts
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
        next if str_list[1].split('/')[2] == 'webcache.googleusercontent.com'
        next if str_list[1].split('/')[2] == 'search.clearch.org'
        next if str_list[1].split('/')[2] == 'duckfm.net'
        next if str_list[1].split('/')[2] == 'search1.speedbit.com'
        next if str_list[1].split('/')[2] == 'yoursearch.me'
        next if str_list[1].split('/')[2] == 'search.speedbit.com'
        next if str_list[1].split('/')[1] == 'preferences?hl=en'
        next if str_list[1].split('/')[2] == 'www.sa-k.net'
        next if str_list[1].split('/')[2] == 'github.com'
        next if str_list[1].split('/')[2] == 'stackoverflow.com'
        urls_to_log = URI.decode(urls)
        Format.success("Site found: #{urls_to_log}")
        sleep(1)
        File.open("#{PATH}/tmp/SQL_sites_to_check.txt", 'a+') { |s| s.puts("#{urls_to_log}'") }
      end
    end
  Format.info("I've dumped possible vulnerable sites into #{PATH}/tmp/SQL_sites_to_check.txt")
end

##############################################################################################
# Start the vulnerability scanning process, basically if the HTML has SQL syntax error in it ###
# it will be output to the LOG file.##########################################################
#####################################

def begin_vulnerability_check
  if ARG == '-f'
    Format.info("Let's check this file out..")
    IO.read("#{PATH}/#{ARGV[1]}").each_line do |vuln|
      begin
        Format.info("Parsing page for SQL syntax error: #{vuln.chomp}")
        Timeout::timeout(10) do
          begin
            if parse("#{vuln.chomp}'", 'html', 0)[/You have an error in your SQL syntax/]
              Format.success("URL: #{vuln.chomp} returned SQL syntax error, temporarily dumped to SQL_VULN.txt")
              File.open("#{PATH}/tmp/SQL_VULN.txt", "a+") { |s| s.puts(vuln) }
              sleep(1)
            else
              Format.warning("URL: #{vuln.chomp} is not vulnerable, dumped to non_exploitable.txt")
              File.open("#{PATH}/log/non_exploitable.txt", "a+") { |s| s.puts(vuln) }
              sleep(1)
            end
          rescue Timeout::Error, OpenSSL::SSL::SSLError
            Format.info("URL: #{vuln.chomp} failed to load dumped to non_exploitable.txt")
            File.open("#{PATH}/log/non_exploitable.txt", "a+") { |s| s.puts(vuln) }
            next
            sleep(1)
          end
        end
      rescue RestClient::ResourceNotFound, RestClient::InternalServerError, RestClient::RequestTimeout, RestClient::Gone, RestClient::SSLCertificateNotVerified, RestClient::Forbidden, OpenSSL::SSL::SSLError, Errno::ECONNREFUSED, URI::InvalidURIError, Errno::ECONNRESET, Timeout::Error, OpenSSL::SSL::SSLError, ArgumentError, RestClient::MultipleChoices, RestClient::Unauthorized, SocketError, RestClient::BadRequest, RestClient::ServerBrokeConnection => e
        Format.err("URL: #{vuln.chomp} failed due to an error while connecting, URL dumped to non_exploitable.txt")
        File.open("#{PATH}/log/non_exploitable.txt", "a+") { |s| s.puts(vuln) }
        next
      end
    end
  elsif ARG == '-d'
    Format.info("I'll run in default mode then!")
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
          rescue Timeout::Error, OpenSSL::SSL::SSLError, SocketError
            Format.info("URL: #{parse.chomp} failed to load dumped to non_exploitable.txt")
            File.open("#{PATH}/log/non_exploitable.txt", "a+") { |s| s.puts(parse) }
            next
            sleep(1)
          end
        end
      rescue RestClient::ResourceNotFound, RestClient::InternalServerError, RestClient::RequestTimeout, RestClient::Gone, RestClient::SSLCertificateNotVerified, RestClient::Forbidden, OpenSSL::SSL::SSLError, Errno::ECONNREFUSED, URI::InvalidURIError, Errno::ECONNRESET, Timeout::Error, OpenSSL::SSL::SSLError, ArgumentError, RestClient::MultipleChoices, SocketError, RestClient::BadRequest,RestClient::ServerBrokeConnection => e
        Format.err("URL: #{parse.chomp} failed due to an error while connecting, URL dumped to non_exploitable.txt")
        File.open("#{PATH}/log/non_exploitable.txt", "a+") { |s| s.puts(parse) }
        next
      end
	end
  else
    Format.info('You didn\'t pass me a flag to use!')
    usage_page
  end
end

#######################################################################################################################
# The extremely long begin rescue clause, basically it will rescue the program if it catches a fatal RestClient error ####
# such as a 503, Google will only allow you 100 search queries within one day, the random user agents will allow you ###
# to do more searches though so this really shouldn't be a problem unless something truly crappy happens. ############
###########################################################################################################

case ARG
  when '-f'
    begin
      Whitewidow.spider
      sleep(1)
      Credits.credits
      sleep(1)
      Legal.legal
      begin_vulnerability_check
      File.truncate("#{PATH}/tmp/SQL_sites_to_check.txt", 0)
      Format.info("I'm truncating SQL_sites_to_check file back to #{File.size("#{PATH}/tmp/SQL_sites_to_check.txt")}")
      Copy.file
      File.truncate("#{PATH}/tmp/SQL_VULN.txt", 0)
      Format.info("I've run all my tests and queries, and logged all important information into #{PATH}/log/SQL_VULN.LOG") unless File.size("#{PATH}/log/SQL_VULN.LOG") == 0
    rescue Mechanize::ResponseCodeError, RestClient::ServiceUnavailable, OpenSSL::SSL::SSLError, RestClient::BadGateway => e
      t = Time.now
      d = DateTime.now
      Format.fatal("Well this is pretty crappy.. I seem to have encountered a #{e} error. I'm gonna take the safe road and quit scanning before I break something. You can either try again, or manually delete the URL that caused the error.")
      File.open("#{PATH}/log/error_log.LOG", 'a+'){ |error| error.puts("[#{d.month}-#{d.day}-#{d.year} :: #{t.hour}:#{t.min}:#{t.sec}]#{e}") }
      Format.info("I'll log the error inside of #{PATH}/log/error_log.LOG for further analysis.")
    end
  when '-d'
    begin
      Whitewidow.spider
      sleep(1)
      Credits.credits
      sleep(1)
      Legal.legal
      get_urls
      begin_vulnerability_check
      File.truncate("#{PATH}/tmp/SQL_sites_to_check.txt", 0)
      Format.info("I'm truncating SQL_sites_to_check file back to #{File.size("#{PATH}/tmp/SQL_sites_to_check.txt")}")
      Copy.file
      File.truncate("#{PATH}/tmp/SQL_VULN.txt", 0)
      Format.info("I've run all my tests and queries, and logged all important information into #{PATH}/log/SQL_VULN.LOG") unless File.size("#{PATH}/log/SQL_VULN.LOG") == 0
    rescue Mechanize::ResponseCodeError, RestClient::ServiceUnavailable, OpenSSL::SSL::SSLError, RestClient::BadGateway => e
      t = Time.now
      d = DateTime.now
      Format.fatal("Well this is pretty crappy.. I seem to have encountered a #{e} error. I'm gonna take the safe road and quit scanning before I break something. You can either try again, or manually delete the URL that caused the error.")
      File.open("#{PATH}/log/error_log.LOG", 'a+'){ |error| error.puts("[#{d.month}-#{d.day}-#{d.year} :: #{t.hour}:#{t.min}:#{t.sec}]#{e}") }
      Format.info("I'll log the error inside of #{PATH}/log/error_log.LOG for further analysis.")
    end
  when '-h'
    usage_page
  when '-hh'
    help_page
  else
    usage_page
end

