# Built in libraries used within whitewidow
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

# Created libraries that are relied on for the program to run
require_relative '../../lib/modules/core/format'
require_relative '../../lib/misc/legal'
require_relative '../../lib/misc/banner'
require_relative '../../lib/modules/core/copy'
require_relative '../../lib/modules/core/site_info'
require_relative '../../lib/modules/expansion/string_expan'
require_relative '../../lib/modules/core/detection'
require_relative '../../lib/modules/core/check_platform'
require_relative '../../lib/modules/core/tools/spider/blackwidow'
require_relative '../../lib/modules/core/settings'

# Modules that need to be included for whitewidow
include MultipleParameters
include Format
include Legal
include Whitewidow
include Copy
include SiteInfo
include BlackWidow
include Settings

# Runs a beep depending on the platform you have
BEEP = Platform::CheckBeep.new

# Check for multiple parameters within a URL
MULTIPARAMS = MultipleParameters::TestAllParameters.new

# Format the output with color coordination and time
FORMAT = Format::StringFormat.new

# The directory you're running in
PATH = Dir.pwd

# Grab a random search query from the lib/lists/search_query.txt file
SEARCH_QUERY = File.readlines("#{PATH}/lib/lists/search_query.txt").sample

# YAML file of random user agents
USER_AGENTS = YAML.load_file("#{PATH}/lib/lists/rand-age.yml")

# Empty hash to append the flags into
OPTIONS = {}

# The version that whitewidow is currently in
VERSION = Whitewidow::Misc.new.version

# What type of version do you have? Is there an upgrade? Stable? Dev version?
VERSION_TYPE = Whitewidow::Misc.new.version_type(VERSION)

# Download link for the banner
DOWNLOAD_LINK = "https://github.com/Ekultek/whitewidow/releases"

# Repository link for the banner
REPO_LINK = "https://github.com/Ekultek/whitewidow"

# The output version string
VERSION_STRING = "v".green + VERSION.green.bold + '('.cyan.bold + VERSION_TYPE + ')'.cyan.bold

# Default user agent used by whitewidow
DEFAULT_USER_AGENT = "Whitewidow #{VERSION} SQL Vuln Scanner Ruby:#{RUBY_VERSION}->Platform:#{RUBY_PLATFORM}"

# Spider a webpage with the blackwidow spider bot (work in progress)
SPIDER_BOT = BlackWidow::RecursiveSpider.new

# Program settings
SETTINGS = Settings::ProgramSettings.new

SQLMAP_PATH = "#{PATH}/lib/modules/tools/sqlmap/sqlmap.py"

# Skip these sites because chances are they will never be vulnerable
SKIP = %w(stackoverflow.com www.stackoverflow.com github.com www.github.com www.sa-k.net yoursearch.me search1.speedbit.com
          duckfm.net search.clearch.org webcache.googleusercontent.com m.facebook.com youtube.com facebook.com
          twitter.com wikipedia.org tumblr.com pinterest.com www.facebook.com pinterest.com www.pinterest.com
          m.pinterest.com)

# Loading errors, basically the page didn't load becasue it's either not vulnerable or doesn't exist
LOADING_ERRORS = [RestClient::ResourceNotFound, RestClient::InternalServerError, RestClient::RequestTimeout,
                  RestClient::Gone, RestClient::SSLCertificateNotVerified, RestClient::Forbidden,
                  OpenSSL::SSL::SSLError, Errno::ECONNREFUSED, URI::InvalidURIError, Errno::ECONNRESET,
                  Timeout::Error, OpenSSL::SSL::SSLError, Zlib::GzipFile::Error, RestClient::MultipleChoices,
                  RestClient::Unauthorized, SocketError, RestClient::BadRequest, RestClient::ServerBrokeConnection,
                  Errno::ECONNABORTED, Zlib::BufError, RestClient::ServiceUnavailable, ArgumentError]

# Fatal program errors, errors that will force the program to close
FATAL_ERRORS = [Mechanize::ResponseCodeError, RestClient::BadGateway, Errno::ENETUNREACH,
                Net::HTTP::Persistent::Error]

# Spider bot errors, still a work in progress
SPIDER_ERRORS = [RestClient::NotFound, URI::InvalidURIError, RestClient::SSLCertificateNotVerified, RestClient::MethodNotAllowed]

# Errors thrown when a webpage has unclosed SQL syntax
vuln_specs = [/SQL query error/, /MySQL Query Error/,
              /expects parameter/, /You have an error in your SQL syntax/]

# Regex created from the above specifications looks something along the lines of:
# /(?-mix:SQL query error)|(?-mix:MySQL Query Error)|(?-mix:expects parameter)|(?-mix:You have an error in your SQL syntax)/
SQL_VULN_REGEX = Regexp.union(vuln_specs)

# Windows platform regex
WINDOWS_PLATFORM_REGEX = [/cygwin|mswin|mingw|bccwin|wince|emx/]

# Mac platform regex
DARWIN_PLATFORM_REGEX = [/darwin/]
