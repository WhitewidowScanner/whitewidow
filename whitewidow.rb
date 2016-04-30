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
# - Another known bug has something to do with how the search queries react when the program is run in default mode.
#   Occasionally you will get a search that looks something like this: searches/preferencess?en=la
#   When you receive this search you may ignore it, because the program will take it as a non exploitable, however,
#   I would like to ask for your help in this matter, when you receive a search result that looks like that one
#   (THE END (en=la) WILL BE DIFFERENT FOR YOU!!) Please scroll down to where you get the urls and add your search result to
#   where it says #<= ADD HERE =>
#   This will require you to fork the repo, and contribute, you may also list the search result in the bug reports
#   HERE: https://github.com/Ekultek/whitewidow/issues/8
#
########################################################################################################################
#
# TODO list:
#
# - Add advanced decoding, what advanced decoding will do is attempt to decode multiple parameters of a URL. So if a URL
#   has more than one equal sign if the first attempts fail, it will attempt to inject SQL vuln syntax into the other
#   equal sign parameters
#
# - Fix IO encoder error, I have a general idea on how to fix this error, the only problem is it keeps happening when
#   I'm not ready for it to (shocking right?). So I'm working on this, don't worry. I'm about 90% sure that it has
#   something to do with the fact that the URL is multi encoded, so I'll have to figure out a way to decode the URL's
#   further if the program throws an encoding error.
#
# - Make whitewidow capable of scraping more then one page. Right now whitewidow can only scrape a max of 10 URL's at
#   a time. That's the first page of Google if you're lucky. However the mechanize gem does indeed give the ability
#   to sort through pages, no I am not good with the mechanize gem. I am still trying to figure out how to use it.
#
# - Will be adding a feature where the program will automatically delete bad search queries, and replace them with
#   possible good search queries. For example if a search query produces no results it will be deleted, and replaced by
#   another one that will be in a separate file. This will be added along with the upgrade of scraping multiple pages.
#   I have begun working on this, the search query list that will replace the deleted queries will be encoded, and I will
#   be adding a module to decode and add the search queries into the file they will be deleted from
#
########################################################################################################################
#
# Some basic information:
#
# So since you're here, and reading this, I'm guessing you want to learn how to use this program, well it's pretty
# simple, as of the new release whitewidow no longer uses ARGV, and uses optparser to parse your options, read the
# readme because your options have changed!
#
# - To scan a file containing the URL's:
#
#   ruby whitewidow.rb -f <path/to/file>
#
#   File will automatically be formatted, so if there are spaces or problems with the file, it will be formatted and
#   run as #sites.txt, your original file will also remain so don't worry about that.
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
require 'tempfile'
require 'socket'
require 'net/http'
require_relative 'lib/modules/format.rb'
require_relative 'lib/modules/credits.rb'
require_relative 'lib/modules/legal.rb'
require_relative 'lib/modules/spider.rb'
require_relative 'lib/modules/copy.rb'
require_relative 'lib/modules/site_info.rb'

include Format
include Credits
include Legal
include Whitewidow
include Copy
include SiteInfo

PATH = Dir.pwd
VERSION = Whitewidow.version
SEARCH = File.readlines("#{PATH}/lib/search_query.txt").sample
info = YAML.load_file("#{PATH}/lib/rand-agents.yaml")
@user_agent = info['user_agents'][info.keys.sample]
OPTIONS = {}

def usage_page
  Format.usage("You can run me with the following flags: #{File.basename(__FILE__)} -[d|e|h] -[f] <path/to/file/if/any>")
  exit
end

def examples_page
  Format.usage('This is my examples page, I\'ll show you a few examples of how to get me to do what you want.')
  Format.usage('Running me with a file: whitewidow.rb -f <path/to/file> keep the file inside of one of my directories.')
  Format.usage('Running me default, if you don\'t want to use a file, because you don\'t think I can handle it, or for whatever reason, you can run me default by passing the Default flag: whitewidow.rb -d this will allow me to scrape Google for some SQL vuln sites, no guarentees though!')
  Format.usage('Running me with my Help flag will show you all options an explanation of what they do and how to use them')
  Format.usage('Running me without a flag will show you the usage page. Not descriptive at all but gets the point across')
end

OptionParser.new do |opt|
  opt.on('-f FILE', '--file FILE', 'Pass a file name to me, remember to drop the first slash. /tmp/txt.txt <= INCORRECT tmp/text.txt <= CORRECT') { |o| OPTIONS[:file] = o }
  opt.on('-d', '--default', 'Run me in default mode, this will allow me to scrape Google using my built in search queries.') { |o| OPTIONS[:default] = o }
  opt.on('-e', '--example', 'Shows my example page, gives you some pointers on how this works.') { |o| OPTIONS[:example] = o }
end.parse!

def page(site)
  Nokogiri::HTML(RestClient.get(site))
end

def parse(site, tag, i)
  parsing = page(site)
  parsing.css(tag)[i].to_s
end

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
      next if urls.split('/')[2].start_with? 'stackoverflow.com', 'github.com', 'www.sa-k.net', 'yoursearch.me', 'search1.speedbit.com', 'duckfm.net', 'search.clearch.org', 'webcache.googleusercontent.com'
      next if urls.start_with?('settings/ads/preferences?hl=en') #<= ADD HERE REMEMBER A COMMA =>
      urls_to_log = URI.decode(urls)
      Format.success("Site found: #{urls_to_log}")
      sleep(1)
      sql_syntax = ["'", "`", "--", ";"].each do |sql|
        File.open("#{PATH}/tmp/SQL_sites_to_check.txt", 'a+') { |s| s.puts("#{urls_to_log}#{sql}") }
      end
    end
  end
  Format.info("I've dumped possible vulnerable sites into #{PATH}/tmp/SQL_sites_to_check.txt")
end

def vulnerability_check
  case
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
        vulns = vuln.encode(Encoding.find('UTF-8'), {invalid: :replace, undef: :replace, replace: ''})
        begin
          if parse("#{vulns.chomp}'", 'html', 0)[/You have an error in your SQL syntax/]
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
          next
          sleep(1)
        end
      end
    rescue RestClient::ResourceNotFound, RestClient::InternalServerError, RestClient::RequestTimeout, RestClient::Gone, RestClient::SSLCertificateNotVerified, RestClient::Forbidden, OpenSSL::SSL::SSLError, Errno::ECONNREFUSED, URI::InvalidURIError, Errno::ECONNRESET, Timeout::Error, OpenSSL::SSL::SSLError, Zlib::GzipFile::Error, RestClient::MultipleChoices, RestClient::Unauthorized, SocketError, RestClient::BadRequest, RestClient::ServerBrokeConnection, RestClient::MaxRedirectsReached => e
      Format.err("URL: #{vuln.chomp} failed due to an error while connecting, URL dumped to non_exploitable.txt")
      File.open("#{PATH}/log/non_exploitable.txt", "a+") { |s| s.puts(vuln) }
      next
    end
  end
end

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
      Format.warn("No sites found for search querie: #{SEARCH}. Logging into error_log.LOG. Create a issue regarding this.") if File.size("#{PATH}/tmp/SQL_sites_to_check.txt") == 0
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
