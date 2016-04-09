#!/usr/local/env ruby

########################################################################################################################
#
# Welcome to the whitewidow source code, below you will find a whole ton of rescue clauses, yes they are necessary.
# Do to the amount of possible errors it's very hard to catch them all, I'm still finding new errors from RestClient,
# Nokogiri, Kernel, etc. I did a count of how many I've found so far and it's added up to about 60. Now having said
# that, there are defiantly a couple known bugs that are being worked on.
#
# Known Bugs:
#
# - One known bug is that every now and then there's an encoding error, I haven't really figured out how to fix this bug
#   yet, but I am working on it. This bug, however, won't error out the program and will continue running, it looks
#   like something along the lines of: 'IO encoder error <some hex> <some more hex>'
#   If you have any information on how to fix this error please let me know. Make a bug report or something, fork the
#   project and start working on it. Do whatever you need to do, to get that thing to out of the way.
#
# - Another known bug is that every now and then (VERY RARELY) Google won't allow you to go onto the search page. I have
#   a pretty good idea on how to fix this one and am in the process of adding a proxy setting for whitewidow.
#   What I'm thinking is, Google allows you upto 100 queries in a day, after that you either have to throw some
#   random headers at it, or change your IP every so often, so my best guess is that due to how many times I've run
#   whitewidow, Google is starting to recognize all the user agents. I'll be adding more of those along with the
#   proxy setting.
#
# - One last known bug is, every now and then the program will pull a site off Google that says something along the
#   lines of: settings/preferences?=en
#   I've tried multiple times to try and catch this, except it keeps showing up. The program WILL completely fail if
#   this "url" is found. I can't catch it (yet), and I can't rescue it (yet). Problem is I have no idea why it would
#   be pulling this off of Google. It's not even a real URL. So I'm working on it. I have been able to make it show
#   up less by removing the queries that would bring it up most often.
#
########################################################################################################################
#
# TODO list:
#
# - Add more user agents, I think this will help with the second known bug I was talking about above. What I think
#   is happening is that Google is starting to notice the agents I'm using, because I've been running this program so
#   much. Will be released in version 1.0.3
#
# - Fix IO encoder error, I have a general idea on how to fix this error, the only problem is it keeps happening when
#   I'm not ready for it to (shocking right?). So I'm working on this, don't worry. I'm about 90% sure that it has
#   something to do with the fact that the URL is multi encoded, so I'll have to figure out a way to decode the URL's
#   further if the program throws an encoding error. Hoping to release by version 1.0.5
#
# - Fix that ridiculous mess of next if's in the vulnerability scan. If you've looked through the source code at all
#   you've probably noticed a giant nasty rats nest of next ifs to skip URLs that I don't want. I'm working on this,
#   I'm going to throw in a method somewhere that will act as the next if, it'll be much cleaner. Will probably be
#   released in version 1.0.3
#
# - Finish the proxy setting. I've begun making a proxy setting for whitewidow (as you can see in the code). It works,
#   but won't connect to the proxy correctly, always throws the whole proxy denied connection, no matter how newly
#   scraped the proxy is. I'll figure it out. Hoping to release by version 1.0.4
#
# - Update the flags from ARGV to OptParser. Yes I know I'm using ARGV for the flags, but that was just so that I could
#   release this version. Believe it or not this is the second version of whitewidow. I didn't release the first two
#   because well, they sucked. Anyways, I will be updating from ARGV to OptParser eventually, probably around 1.0.4
#
# - Fix the vulnerability check method. Right now this program is way to reliant on that method and I don't like that.
#   I have an idea of how I can cut the method down, but I'll have to make multiple methods containing close to the
#   same information. This will come when I change the flags from ARGV to OptParser; version 1.0.4
#
# - Make whitewidow capable of scraping more then one page. Right now whitewidow can only scrape a max of 10 URL's at
#   a time. That's the first page of Google if you're lucky. However the mechanize gem does indeed give the ability
#   to sort through pages, no I am not good with the mechanize gem. I am still trying to figure out how to use it.
#   I'm hoping to have this upgrade done by the release of 1.0.5
#
# - Will be adding further analysis of URL's that get dumped to the non exploitable log. What I mean is I will be
#   giving the program a way to try and find a vulnerability in the site, probably by using a spider bot or something.
#   Also the sites that are in the non exploitable log file will never be run again if they have been run once.
#   Hopefully this will be released by 1.0.5
#
# - Will be adding a feature where the program will automatically delete bad search queries. For example if a search
#   query produces no results it will be deleted, this will be added along with the upgrade of scraping multiple
#   pages. 1.0.5
#
########################################################################################################################
#
# Some basic information:
#
# So since you're here, and reading this, I'm guessing you want to learn how to use this program, well it's pretty
# simple, as of the new release (version 1.0.2) it use ARGV as the argument parser. So basically all you have to do is
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

   NONE OF THIS IS READY YET

OPTIONS = Struct.new(:default, :file, :example)
attr_accessor :default, :file, :example

def self.parse(options)
  ARGS = OPTIONS.new
  opt_parser = OptionParser.new do |opts|
    opts.banner = usage_page
    opts.on('-d', '--default', 'Run me in default mode, I\'ll scrape Google for SQL vulns.') do |d|
      ARGS.default = d
    end
    opts.on('-fFILE', '--file=FILE', 'Pass me the name of the file. Leave out the beginning forward slash. (/lib/ <= incorrect lib/ <=correct)') do |f|
      ARGS.file = f
    end
    opts.on('-e', '--example', 'Shows my example page. It\'s really not that hard to figure out, bt I\'m a nice albino widow.') do |e|
      examples_page
      exit
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
  return ARGS
end


case ARGS
  when options.default

  when options.file

  when options.example
    examples_page
  else
    usage_page
  end
end

def pull_proxy
  info = parse("http://www.nntime.com/",'.odd', 1)
  @ip = info[/\D\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\D/].gsub(">", "").gsub("<", "")
  @port = info[/8080/] || info[/3128/] || info[/80/] || info[/3129/] || info[/6129/]  #Not ready yet
  proxy = "#{@ip}:#{@port}"
  Format.info("Proxy discovered: #{proxy}")
end
=end

require 'mechanize'
require 'nokogiri'
require 'restclient'
require 'timeout'
require 'uri'
require 'fileutils'
require 'colored'
require 'yaml'
require 'date'
require 'optparse'
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
  Format.usage("You can run me with the following flags: #{File.basename(__FILE__)} -[d|e|h|u] -[f] <path/to/file/if/any>")
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
        next if urls.split('/')[2] == 'webcache.googleusercontent.com'
        next if urls.split('/')[2] == 'search.clearch.org'
        next if urls.split('/')[2] == 'duckfm.net'
        next if urls.split('/')[2] == 'search1.speedbit.com'
        next if urls.split('/')[2] == 'yoursearch.me'
        next if urls.split('/')[1] == 'preferences?hl=en'
        next if urls.split('/')[2] == 'www.sa-k.net'
        next if urls.split('/')[2] == 'github.com'
        next if urls.split('/')[2] == 'stackoverflow.com'
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
      Copy.file
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
    help_page
  else
    usage_page
end