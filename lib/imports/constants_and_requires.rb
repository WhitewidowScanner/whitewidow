# Built in libraries
require 'rubygems'
require 'bundler/setup'
require 'mechanize'
require 'nokogiri'
require 'rest-client'
require 'timeout'
require 'uri'
require 'fileutils'
require 'yaml'
require 'date'
require 'optparse'
require 'tempfile'
require 'socket'
require 'net/http'

# Created libraries
require_relative '../../lib/modules/format'
require_relative '../../lib/misc/credits'
require_relative '../../lib/misc/legal'
require_relative '../../lib/misc/spider'
require_relative '../../lib/modules/copy'
require_relative '../../lib/modules/site_info'
require_relative '../../lib/modules/expansion/string_expan'

# Modules that need to be included
include Format
include Credits
include Legal
include Whitewidow
include Copy
include SiteInfo

# Constants used throughout the program
=begin
USER_AGENTS = { # Temporary fix for user agents until I can refactor the YAML file
    1 => 'Mozilla/5.0 (compatible; 008/0.83; http://www.80legs.com/webcrawler.html) Gecko/2008032620',
    2 => 'Mozilla/5.0 (compatible; U; ABrowse 0.6; Syllable) AppleWebKit/420+ (KHTML, like Gecko)',
    3 => 'Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.3pre) Gecko/20100403 Lorentz/3.6.3plugin2pre (.NET CLR 4.0.20506)',
    4 => 'Mozilla/5.0 (compatible; Yahoo! Slurp; http://help.yahoo.com/help/us/ysearch/slurp)',
    5 => 'igdeSpyder (compatible; igde.ru; +http://igde.ru/doc/tech.html)',
    6 => 'larbin_2.6.3 (ltaa_web_crawler@groupes.epfl.ch)',
    7 => 'Mozilla/5.0 (Linux; Android 5.0.2; SAMSUNG SM-T550 Build/LRX22G) AppleWebKit/537.36 (KHTML, like Gecko) SamsungBrowser/3.3 Chrome/38.0.2125.102 Safari/537.36',
    8 => 'Dalvik/2.1.0 (Linux; U; Android 6.0.1; Nexus Player Build/MMB29T)',
    9 => 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:15.0) Gecko/20100101 Firefox/15.0.1',
    10 => 'Mozilla/5.0 (compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm)',
}
=end
FORMAT = Format::StringFormat.new
PATH = Dir.pwd
VERSION = Whitewidow.version
SEARCH = File.readlines("#{PATH}/lib/lists/search_query.txt").sample
agents = YAML.load_file("#{PATH}/lib/lists/rand-age.yml")
OPTIONS = {}
USER_AGENT = agents[rand(1..20)]
SKIP = %w(/webcache.googleusercontent.com stackoverflow.com github.com)
LOADING_ERRORS = [RestClient::ResourceNotFound, RestClient::InternalServerError, RestClient::RequestTimeout,
                RestClient::Gone, RestClient::SSLCertificateNotVerified, RestClient::Forbidden,
                OpenSSL::SSL::SSLError, Errno::ECONNREFUSED, URI::InvalidURIError, Errno::ECONNRESET,
                Timeout::Error, OpenSSL::SSL::SSLError, Zlib::GzipFile::Error, RestClient::MultipleChoices,
                RestClient::Unauthorized, SocketError, RestClient::BadRequest, RestClient::ServerBrokeConnection,
                RestClient::MaxRedirectsReached]
FATAL_ERRORS = [Mechanize::ResponseCodeError, RestClient::ServiceUnavailable, OpenSSL::SSL::SSLError,
                RestClient::BadGateway]