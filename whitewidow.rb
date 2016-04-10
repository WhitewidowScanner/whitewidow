#!/usr/local/env ruby

########################################################################################################################
#
# Welcome to the whitewidow source code, below you will find a whole ton of rescue clauses, yes they are necessary.
# Do to the amount of possible errors it's very hard to catch them all, I'm still finding new errors from RestClient,
# Nokogiri, Kernel, etc. I did a count of how many I've found so far and it's added up to about 60. Now having said
# that, there are defiantly a couple known bugs that are being worked on.
#
########################################################################################################################
#
# Known Bugs:
#
# - One known bug is that every now and then there's an encoding error, I haven't really figured out how to fix this bug
#   yet, but I am working on it. This bug, however, won't error out the program and will continue running, it looks
#   like something along the lines of: 'IO encoder error <some hex> <some more hex>'
#   If you have any information on how to fix this error please let me know. Make a bug report or something, fork the
#   project and start working on it. Do whatever you need to do, to get that thing to out of the way.
#
#   04/07/16 UPDATE:
#
#   Well, I've discovered a possible temporary solution to the encoding error, however it requires some Ruby
#   flags to be run, and doesn't always work, in order to eliminate the encoding error you must run the program
#   with the following flags:
#
#            > ruby whitewidow.rb -[d|u] -f <path/to/file> -EBINARY -EASCII-8BIT -Kn -Ku <
#
#   This will get rid of the encoding errors SOMETIMES still working on permanent patch for this issue.
#
# - Another known bug is that every now and then (VERY RARELY) Google won't allow you to go onto the search page. I have
#   a pretty good idea on how to fix this one and am in the process of adding a proxy setting for whitewidow.
#   What I'm thinking is, Google allows you upto 100 queries in a day, after that you either have to throw some
#   random headers at it, or change your IP every so often, so my best guess is that due to how many times I've run
#   whitewidow, Google is starting to recognize all the user agents. I'll be adding more of those along with the
#   proxy setting.
#
# - Well that stupid search/preferences things is back, so there's another bug. When you see this in the file, stop
#   the process, manually delete that specific line (for now) and start again, trust me it'll cause a whole bunch of
#   crappy problems that you don't want to deal with.
#
########################################################################################################################
#
# TODO list:
#
# - Add advanced decoding module, this will attempt to further decode the URLs that are dumped to non exploitable, if
#   they are able to be further decoded, it will once again try to find a SQL vuln in the webpage. I think this should
#   help with the encoding errors, I'm not sure though. Will be in version 1.0.6
#
# - Fix IO encoder error, I have a general idea on how to fix this error, the only problem is it keeps happening when
#   I'm not ready for it to (shocking right?). So I'm working on this, don't worry. I'm about 90% sure that it has
#   something to do with the fact that the URL is multi encoded, so I'll have to figure out a way to decode the URL's
#   further if the program throws an encoding error. Hoping to release by version unknown
#   (SEE UPDATE FOR TEMP SOLUTION^)
#
# - Finish the proxy setting. I've begun making a proxy setting for whitewidow (as you can see in the code). It works,
#   but won't connect to the proxy correctly, always throws the whole proxy denied connection, no matter how newly
#   scraped the proxy is. I'll figure it out. Hoping to release by version 1.0.6
#
# - Make whitewidow capable of scraping more then one page. Right now whitewidow can only scrape a max of 10 URL's at
#   a time. That's the first page of Google if you're lucky. However the mechanize gem does indeed give the ability
#   to sort through pages, no I am not good with the mechanize gem. I am still trying to figure out how to use it.
#   I'm hoping to have this upgrade done by the release of 1.0.6
#
# - Will be adding further analysis of URL's that get dumped to the non exploitable log. What I mean is I will be
#   giving the program a way to try and find a vulnerability in the site, probably by using a spider bot or something.
#   Also the sites that are in the non exploitable log file will never be run again if they have been run once.
#   Hopefully this will be released by 1.0.7
#
# - Will be adding a feature where the program will automatically delete bad search queries, and replace them with
#   possible good search queries. For example if a search query produces no results it will be deleted, and replaced by
#   another one that will be in a separate file.
#   This will be added along with the upgrade of scraping multiple pages. Should be done by version 1.0.6
#
# - Fix that damn specify/preferences thing that shows up randomly for no apparent reason, if you find one open an issue
#   apparently there's a bunch of them, so if you see one that differs from any others please let me know. I have an
#   idea on how I'm going to fix this, I'm going to allow them to happen for awhile and throw them into a file, from
#   from that file, I'm going to read them and if the URL matches them skip over it. I think this will work, because I
#   Don't get them anymore from what I coded in (the next if). So my best guess is that everybody has a different
#   version of it, see the bug report here: https://github.com/Ekultek/whitewidow/issues/6
#   Notice how that one differs from mine.. Hopefully done by version 1.0.6
#
# - Finish conversion from ARGV to optparser, next update 1.0.6
#
########################################################################################################################
#
# Some basic information:
#
# So since you're here, and reading this, I'm guessing you want to learn how to use this program, well it's pretty
# simple, as of the new release (version 1.0.3) it uses ARGV as the argument parser. So basically all you have to do is
# run the following:
#
# - To scan a file containing the URL's:
#
#   ruby whitewidow.rb -f <path/to/file>
#
#   Here's the thing with the file scanning, you have to make sure that the file is within one of the programs
#   directories (log, tmp, lib). Otherwise whitewidow will have no idea what the heck you're talking about. Also you
#   have to make sure that you DO NOT put a forward slash at the beginning of the path, whitewidow already has the
#   slash, so you don't need it.
#
# - To run whitewidow in default mode, and scrape Google for URL's:
#
#   ruby whitewidow.rb -d
#
#   This will scrape Google for the URL's by using one of the search queries in the lib directory. There's a bunch of
#   them so chances are you won't get the same one twice in a row. However, there are no guarantees that you will
#   find vulnerable sites this way. The easiest way is to pull a bunch of URL's and run them through this program.
#
########################################################################################################################

=begin

   #NONE OF THIS IS READY YET

require 'rubygems'
require 'bundler/setup'
require 'mechanize'
require 'nokogiri'
require 'rest-client'
require 'timeout'
require 'uri'
require 'fileutils'
require 'colored'
require 'yaml'
require 'date'
require 'optparse'
require 'pp'
require_relative 'lib/format.rb'
require_relative 'lib/credits.rb'
require_relative 'lib/legal.rb'
require_relative 'lib/spider.rb'
require_relative 'lib/copy.rb'
#require_relative 'lib/extra/advanced.rb'

#include AdvancedDecoding
include Format
include Credits
include Legal
include Whitewidow
include Copy

PATH = Dir.pwd
VERSION = Whitewidow.version
SEARCH = File.readlines("#{PATH}/lib/search_query.txt").sample
info = YAML.load_file("#{PATH}/lib/rand-agents.yaml")
@user_agent = info['user_agents'][info.keys.sample]
OPTIONS = Struct.new(:default, :file, :example)

def usage_page
  Format.usage("You can run me with the following flags: #{File.basename(__FILE__)} -[d|e|h] -[f] <path/to/file/if/any>")
  exit
end

#def reattempt_decoding
#  AdvancedDecoding.advanced_url_decoding   # NOT READY YET
#end

def examples_page
  Format.usage('This is my examples page, I\'ll show you a few examples of how to get me to do what you want.')
  Format.usage('Running me with a file: whitewidow.rb -f <path/to/file> keep the file inside of one of my directories.')
  Format.usage('Running me default, if you don\'t want to use a file, because you don\'t think I can handle it, or for whatever reason, you can run me default by passing the Default flag: whitewidow.rb -d this will allow me to scrape Google for some SQL vuln sites, no guarentees though!')
  Format.usage('Running me with my Usage flag will show you the boring usage page.. Yeah it\'s not very exciting..')
end

class OptParse

  def self.parse_argv(options)
    args = OPTIONS.new
    opt_parser = OptionParser.new do |opts|
      opts.banner = usage_page
      opts.on('-d', '--default', 'Run me in default mode, I\'ll scrape Google for SQL vulns.') do |d|
        args.default = d
      end
      opts.on('-f=FILE', '--file=FILE', File, 'Pass me the name of the file. Leave out the beginning forward slash. (/lib/ <= incorrect lib/ <=correct)') do |f|
        args.file = f
      end
      opts.on('-e', '--example', 'Shows my example page. It\'s really not that hard to figure out, but I\'m a nice albino widow.') do |e|
	  args.example = e
      end
      opts.on('-h', '--help', 'Shows a complete list of all my usages, with what they do, and their secondary flag.') do
        puts opts
        exit
      end
      opts.on('-u', '--usage', 'Shows my usage page, a short list of possible flags, use the help flag (-h) for a more complete list.') do
        usage_page
        exit
      end
    end
    opt_parser.parse!(options)
    return args
  end
end

def pull_proxy
  info = parse("http://www.nntime.com/",'.odd', 1)
  @ip = info[/\D\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\D/].gsub(">", "").gsub("<", "")
  @port = info[/8080/] || info[/3128/] || info[/80/] || info[/3129/] || info[/6129/]
  proxy = "#{@ip}:#{@port}"
  Format.info("Proxy discovered: #{proxy}")
end

def page(site)
  Nokogiri::HTML(RestClient.get(site))
end

def parse(site, tag, i)
  parsing = page(site)
  parsing.css(tag)[i].to_s
end

def get_urls
  if options.default
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
          next if urls.split('/')[2].start_with? 'stackoverflow.com', 'github.com', 'www.sa-k.net', 'yoursearch.me', 'search1.speedbit.com', 'duckfm.net', 'search.clearch.org', 'webcache.googleusercontent.com'
          next if urls.split('/')[1].start_with? 'ads/preferences?hl=en'
          urls_to_log = URI.decode(urls)
          Format.success("Site found: #{urls_to_log}")
          sleep(1)
          File.open("#{PATH}/tmp/SQL_sites_to_check.txt", 'a+') { |s| s.puts("#{urls_to_log}'") }
        end
      end
    Format.info("I've dumped possible vulnerable sites into #{PATH}/tmp/SQL_sites_to_check.txt")
  else
    begin_vulnerability_check
  end
end

def begin_vulnerability_check
  (options.file) ? file = IO.read(ARGV[1]):file = IO.read("#{PATH}/tmp/SQL_sites_to_check.txt")
  (options.file) ? Format.info('Let\'s check this file out') : Format.info('I\'ll run in default mode then!')
  file.each_line do |vuln|
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
  usage_page if OPTIONS.nil?
end

options = OptParse.parse_argv(ARGV)
pp options
pp ARGV

#=begin
case options
  when options.default || options.file
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
      Copy.file("#{PATH}/tmp/SQL_VULN.txt", "#{PATH}/log/SQL_VULN.LOG")
      File.truncate("#{PATH}/tmp/SQL_VULN.txt", 0)
      Format.info("I've run all my tests and queries, and logged all important information into #{PATH}/log/SQL_VULN.LOG") unless File.size("#{PATH}/log/SQL_VULN.LOG") == 0
    rescue Mechanize::ResponseCodeError, RestClient::ServiceUnavailable, OpenSSL::SSL::SSLError, RestClient::BadGateway => e
      d = DateTime.now
      Format.fatal("Well this is pretty crappy.. I seem to have encountered a #{e} error. I'm gonna take the safe road and quit scanning before I break something. You can either try again, or manually delete the URL that caused the error.")
      File.open("#{PATH}/log/error_log.LOG", 'a+'){ |error| error.puts("[#{d.month}-#{d.day}-#{d.year} :: #{Time.now.strftime("%T")}]#{e}") }
      Format.info("I'll log the error inside of #{PATH}/log/error_log.LOG for further analysis.")
    end
  when options.example
    examples_page
  else
    Format.info("You failed to pass me a flag, let's try again and pass a flag this time!")
  end

=end

########################################################################################################################
#      Good source code below this line, the stuff above this line isn't ready yet, or is just the comments            #
########################################################################################################################

#=begin
require 'rubygems'
require 'bundler/setup'
require 'mechanize'
require 'nokogiri'
require 'rest-client'
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

args = ARGV.dup
ARG = args.shift
PATH = Dir.pwd
VERSION = Whitewidow.version
SEARCH = File.readlines("#{PATH}/lib/search_query.txt").sample
info = YAML.load_file("#{PATH}/lib/rand-agents.yaml")
@user_agent = info['user_agents'][info.keys.sample]

def usage_page
  Format.usage("You can run me with the following flags: #{File.basename(__FILE__)} -[d|h|hh] -[f] <path/to/file/if/any>")
  exit
end

def examples_page
  Format.usage('This is my examples page, I\'ll show you a few examples of how to get me to do what you want.')
  Format.usage('Running me with a file: whitewidow.rb -f <path/to/file> keep the file inside of one of my directories.')
  Format.usage('Running me default, if you don\'t want to use a file, because you don\'t think I can handle it, or for whatever reason, you can run me default by passing the Default flag: whitewidow.rb -d this will allow me to scrape Google for some SQL vuln sites, no guarentees though!')
  Format.usage('Running me with my Usage flag will show you the boring usage page.. Yeah it\'s not very exciting..')
end

def page(site)
  Nokogiri::HTML(RestClient.get(site))
end

def parse(site, tag, i)
  parsing = page(site)
  parsing.css(tag)[i].to_s
end

def get_urls
  Format.info('I\'ll run in default mode then!')
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
        next if urls.split('/')[2].start_with? 'stackoverflow.com', 'github.com', 'www.sa-k.net', 'yoursearch.me', 'search1.speedbit.com', 'duckfm.net', 'search.clearch.org', 'webcache.googleusercontent.com'
        next if urls.split('/')[1].start_with? 'ads/preferences?hl=en'
        urls_to_log = URI.decode(urls)
        Format.success("Site found: #{urls_to_log}")
        sleep(1)
        File.open("#{PATH}/tmp/SQL_sites_to_check.txt", 'a+') { |s| s.puts("#{urls_to_log}'") }
      end
    end
  Format.info("I've dumped possible vulnerable sites into #{PATH}/tmp/SQL_sites_to_check.txt")
end

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
      Copy.file("#{PATH}/tmp/SQL_VULN.txt", "#{PATH}/log/SQL_VULN.LOG")
      File.truncate("#{PATH}/tmp/SQL_VULN.txt", 0)
      Format.info("I've run all my tests and queries, and logged all important information into #{PATH}/log/SQL_VULN.LOG") unless File.size("#{PATH}/log/SQL_VULN.LOG") == 0
    rescue Mechanize::ResponseCodeError, RestClient::ServiceUnavailable, OpenSSL::SSL::SSLError, RestClient::BadGateway => e
      d = DateTime.now
      Format.fatal("Well this is pretty crappy.. I seem to have encountered a #{e} error. I'm gonna take the safe road and quit scanning before I break something. You can either try again, or manually delete the URL that caused the error.")
      File.open("#{PATH}/log/error_log.LOG", 'a+'){ |error| error.puts("[#{d.month}-#{d.day}-#{d.year} :: #{Time.now.strftime("%T")}]#{e}") }
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
      Copy.file("#{PATH}/tmp/SQL_VULN.txt", "#{PATH}/log/SQL_VULN.LOG")
      File.truncate("#{PATH}/tmp/SQL_VULN.txt", 0)
      Format.info("I've run all my tests and queries, and logged all important information into #{PATH}/log/SQL_VULN.LOG") unless File.size("#{PATH}/log/SQL_VULN.LOG") == 0
    rescue Mechanize::ResponseCodeError, RestClient::ServiceUnavailable, OpenSSL::SSL::SSLError, RestClient::BadGateway => e
      d = DateTime.now
      Format.fatal("Well this is pretty crappy.. I seem to have encountered a #{e} error. I'm gonna take the safe road and quit scanning before I break something. You can either try again, or manually delete the URL that caused the error.")
      File.open("#{PATH}/log/error_log.LOG", 'a+'){ |error| error.puts("[#{d.month}-#{d.day}-#{d.year} :: #{Time.now.strftime("%T")}]#{e}") }
      Format.info("I'll log the error inside of #{PATH}/log/error_log.LOG for further analysis.")
    end
  when '-h'
    usage_page
  when '-hh'
    examples_page
  else
    usage_page
end
#=end
