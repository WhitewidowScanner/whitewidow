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
require_relative '../../lib/modules/core/format'
require_relative '../../lib/misc/legal'
require_relative '../../lib/misc/banner'
require_relative '../../lib/modules/core/copy'
require_relative '../../lib/modules/core/site_info'
require_relative '../../lib/modules/expansion/string_expan'
require_relative '../../lib/modules/core/detection'
require_relative '../../lib/modules/core/check_platform'
require_relative '../../lib/modules/spider/blackwidow'
require_relative '../../lib/modules/core/settings'

# Modules that need to be included
include MultipleParameters
include Format
include Legal
include Whitewidow
include Copy
include SiteInfo
include BlackWidow
include Settings

# Constants used throughout the program
BEEP = Platform::CheckBeep.new
MULTIPARAMS = MultipleParameters::TestAllParameters.new
FORMAT = Format::StringFormat.new
PATH = Dir.pwd
SEARCH_QUERY = File.readlines("#{PATH}/lib/lists/search_query.txt").sample
USER_AGENTS = YAML.load_file("#{PATH}/lib/lists/rand-age.yml")
OPTIONS = {}
VERSION = Whitewidow::Misc.new.version
VERSION_TYPE = Whitewidow::Misc.new.version_type(VERSION)
VERSION_STRING = "v" + VERSION.green.bold + '(' + VERSION_TYPE + ')'
DEFAULT_USER_AGENT = "Whitewidow #{VERSION} SQL Vuln Scanner Ruby:#{RUBY_VERSION}->Platform:#{RUBY_PLATFORM}"
SPIDER_BOT = BlackWidow::RecursiveSpider.new
SETTINGS = Settings::ProgramSettings.new

# Skips and errors
SKIP = %w(stackoverflow.com www.stackoverflow.com github.com www.github.com www.sa-k.net yoursearch.me search1.speedbit.com
          duckfm.net search.clearch.org webcache.googleusercontent.com m.facebook.com youtube.com facebook.com
          twitter.com wikipedia.org tumblr.com pinterest.com www.facebook.com pinterest.com www.pinterest.com
          m.pinterest.com)
LOADING_ERRORS = [RestClient::ResourceNotFound, RestClient::InternalServerError, RestClient::RequestTimeout,
                  RestClient::Gone, RestClient::SSLCertificateNotVerified, RestClient::Forbidden,
                  OpenSSL::SSL::SSLError, Errno::ECONNREFUSED, URI::InvalidURIError, Errno::ECONNRESET,
                  Timeout::Error, OpenSSL::SSL::SSLError, Zlib::GzipFile::Error, RestClient::MultipleChoices,
                  RestClient::Unauthorized, SocketError, RestClient::BadRequest, RestClient::ServerBrokeConnection,
                  Errno::ECONNABORTED, Zlib::BufError, RestClient::ServiceUnavailable, ArgumentError]
FATAL_ERRORS = [Mechanize::ResponseCodeError, RestClient::BadGateway, Errno::ENETUNREACH,
                Net::HTTP::Persistent::Error]
SPIDER_ERRORS = [RestClient::NotFound, URI::InvalidURIError, RestClient::SSLCertificateNotVerified]

# Regexps
vuln_specs = [/SQL query error/, /MySQL Query Error/,
              /expects parameter/, /You have an error in your SQL syntax/]
SQL_VULN_REGEX = Regexp.union(vuln_specs)
WINDOWS_PLATFORM_REGEX = [/cygwin|mswin|mingw|bccwin|wince|emx/]
DARWIN_PLATFORM_REGEX = [/darwin/]
