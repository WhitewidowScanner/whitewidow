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
require 'ipaddr'

# Created libraries that are relied on for the program to run
require_relative '../../lib/helpers/file_helper'
require_relative '../../lib/modules/core/format'
require_relative '../../lib/misc/legal'
require_relative '../../lib/misc/banner'
require_relative '../../lib/modules/core/site_info'
require_relative '../../lib/modules/expansion/string_expan'
require_relative '../../lib/modules/core/detection'
require_relative '../../lib/modules/core/check_platform'
require_relative '../../lib/modules/core/tools/spider/blackwidow'
require_relative '../../lib/modules/core/settings'
require_relative '../../lib/modules/core/template/issue_template'
require_relative '../../lib/whitewidow/scanner'
require_relative '../../lib/helpers/sqlmap_config_helper'

# Modules that need to be included for whitewidow
include MultipleParameters
include Format
include Legal
include Whitewidow
include SiteInfo
include BlackWidow
include Settings
include Template

# Runs a beep depending on the platform you have
BEEP = Platform::CheckOS.new

# Check for multiple parameters within a URL
MULTIPARAMS = MultipleParameters::TestAllParameters.new

# Format the output with color coordination and time
FORMAT = Format::StringFormat.new

# The directory you're running in
PATH = Dir.pwd

# Program settings
SETTINGS = Settings::ProgramSettings.new

# Verify the python environment variables
PYTHON_ENV_VAR = SqlmapConfigHelper.find_python_env_var

# Grab a random search query from the lib/lists/search_query.txt file
DEFAULT_SEARCH_QUERY = File.readlines("#{PATH}/lib/lists/search_query.txt").sample

# Grab a random common column from the file and attempt to use it for an exploit
COLUMN_NAME = File.readlines("#{PATH}/lib/lists/common_columns.txt").sample

# YAML file of random user agents
USER_AGENTS = YAML.load_file("#{PATH}/lib/lists/rand-age.yml")

# Empty hash to append the flags into
OPTIONS = {}

# The version that whitewidow is currently in
VERSION = Whitewidow::Misc.new.version

# What type of version do you have? Is there an upgrade? Stable? Dev version?
VERSION_TYPE = Whitewidow::Misc.new.version_type(VERSION)

# Download link for the banner
DOWNLOAD_LINK = "Downloads: https://github.com/WhitewidowScanner/whitewidow/releases".cyan

# Repository link for the banner
REPO_LINK = "Clone: https://github.com/WhitewidowScanner/whitewidow.git".cyan

# The output version string
VERSION_STRING = "v".green + VERSION.green.bold + '('.cyan.bold + VERSION_TYPE + ')'.cyan.bold

# Ruby downloads link
RUBY_DOWNLOAD_LINK = "https://www.ruby-lang.org/en/"

# Python download link
PYTHON_DOWNLOAD_LINK = "https://www.python.org/downloads/"

# Default user agent used by whitewidow
DEFAULT_USER_AGENT = "Whitewidow #{VERSION} SQL Vuln Scanner/Ruby:#{RUBY_VERSION}->Platform:#{RUBY_PLATFORM}"

# Link to whitewidows function page on the wiki
FUNCTION_PAGE_LINK = "https://github.com/WhitewidowScanner/whitewidow/wiki/Functionality"

# Spider a webpage with the blackwidow spider bot (work in progress)
SPIDER_BOT = BlackWidow::RecursiveSpider.new

# Create an issue
CREATE_ISSUE = Template::Templates.new

# Path to sqlmap
SQLMAP_PATH = "#{PATH}/lib/modules/core/tools/sqlmap/sqlmap.py"

# Path to the error log for fatal errors
ERROR_LOG_PATH = FileHelper.open_or_create("#{PATH}/log/error_log.LOG")

# Configuration file for sqlmap
SQLMAP_CONFIG_PATH = FileHelper.open_or_create("#{PATH}/lib/lists/default_sqlmap_config.txt")

# Path to the SQL_VULN.LOG file
SQL_VULN_SITES_LOG = FileHelper.open_or_create("#{PATH}/log/SQL_VULN.LOG")

# Path to temp vuln log
TEMP_VULN_LOG = FileHelper.open_or_create("#{PATH}/tmp/SQL_VULN.txt")

# Path to the sql_sites_to_check file
SITES_TO_CHECK_PATH = FileHelper.open_or_create("#{PATH}/tmp/SQL_sites_to_check.txt")

# Path to the search query blacklist
QUERY_BLACKLIST_PATH = FileHelper.open_or_create("#{PATH}/log/blacklists/query_blacklist")

# Path to non_exploitable.txt
NON_EXPLOITABLE_PATH = FileHelper.open_or_create("#{PATH}/log/non_exploitable.txt")

# Path to the file when the file flag is used
FILE_FLAG_FILE_PATH = FileHelper.open_or_create("#{PATH}/tmp/#sites.txt")

# Blackwidow log file path
BLACKWIDOW_LOG = FileHelper.open_or_create("#{PATH}/tmp/blackwidow_log.txt")

# Issue path
ISSUE_TEMPLATE_PATH = FileHelper.open_or_create("#{PATH}/tmp/issues/#{SETTINGS.random_issue_name}.txt")

# Path to random user agents
RAND_AGENT_PATH = "#{PATH}/lib/lists/rand-age.yml"

# Blind based sql injection test parameters
BLIND_BASED_SQL_INJECTION_TEST = ['AND 1=1', 'OR 13=13', 'AND 13=13']

# Error based sql injection test parameters
ERROR_BASED_SQL_INJECTION_TEST = %w(' -- ; " /* '/* '-- "-- '; "; `)

# Union based sql injection test parameters
UNION_BASED_SQL_INJECTION_TEST = [" SELECT #{COLUMN_NAME}", " union select #{COLUMN_NAME}",
                                  " false union select #{COLUMN_NAME}"]

# Basic legal disclaimer of the program, for full legal and TOS run --legal
BASIC_LEGAL_DISCLAIMER = "[ ! ] Use of this program for malicious intent is illegal. For more information run the --legal flag".red

=begin
SEARCH_ENGINES = {
    "http://google.com": "q",
    "http://www.bing.com/": "q",
    "http://www.dogpile.com/": "q"
}
=end

# Skip these sites because chances are they will never be vulnerable
SKIP = %w(stackoverflow.com www.stackoverflow.com github.com www.github.com www.sa-k.net yoursearch.me search1.speedbit.com
          duckfm.net search.clearch.org webcache.googleusercontent.com m.facebook.com youtube.com facebook.com
          twitter.com wikipedia.org tumblr.com pinterest.com www.facebook.com pinterest.com www.pinterest.com
          m.pinterest.com go.speedbit.com speedbit.com codegists.com)

# Loading errors, basically the page didn't load becasue it's either not vulnerable or doesn't exist
LOADING_ERRORS = [RestClient::ResourceNotFound, RestClient::InternalServerError, RestClient::RequestTimeout,
                  RestClient::Gone, RestClient::SSLCertificateNotVerified, RestClient::Forbidden,
                  OpenSSL::SSL::SSLError, Errno::ECONNREFUSED, URI::InvalidURIError, Errno::ECONNRESET,
                  Timeout::Error, OpenSSL::SSL::SSLError, Zlib::GzipFile::Error, RestClient::MultipleChoices,
                  RestClient::Unauthorized, SocketError, RestClient::BadRequest, RestClient::ServerBrokeConnection,
                  Errno::ECONNABORTED, Zlib::BufError, RestClient::ServiceUnavailable, ArgumentError]

# Fatal program errors, errors that will force the program to close
FATAL_ERRORS = [RestClient::BadGateway, Errno::ENETUNREACH, Net::HTTP::Persistent::Error,
                Mechanize::ResponseCodeError]

# Spider bot errors, still a work in progress
SPIDER_ERRORS = [RestClient::NotFound, URI::InvalidURIError, RestClient::SSLCertificateNotVerified,
                 RestClient::MethodNotAllowed]

# Errors thrown when a webpage has unclosed SQL syntax
vuln_specs = [/SQL query error/, /MySQL Query Error/,
              /expects parameter/, /You have an error in your SQL syntax/,
              /Syntax error:/]

# Regex created from the above specifications looks something along the lines of:
# /(?-mix:SQL query error)|(?-mix:MySQL Query Error)|(?-mix:expects parameter)|(?-mix:You have an error in your SQL syntax)/
SQL_VULN_REGEX = Regexp.union(vuln_specs)

# Windows platform regex
WINDOWS_PLATFORM_REGEX = [/cygwin|mswin|mingw|bccwin|wince|emx/]

# Mac platform regex
DARWIN_PLATFORM_REGEX = [/darwin/]

# Regex for IPv6 tp recognize that it's v6 and not v4
IPV6_REGEX = /(([0-9a-fA-F]{1,4}:){7,7}[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,7}:|([0-9a-fA-F]{1,4}:){1,6}:
               [0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,5}(:[0-9a-fA-F]{1,4}){1,2}|([0-9a-fA-F]{1,4}:){1,4}
               (:[0-9a-fA-F]{1,4}){1,3}|([0-9a-fA-F]{1,4}:){1,3}(:[0-9a-fA-F]{1,4}){1,4}|([0-9a-fA-F]{1,4}:){1,2}
               (:[0-9a-fA-F]{1,4}){1,5}|[0-9a-fA-F]{1,4}:((:[0-9a-fA-F]{1,4}){1,6})|:((:[0-9a-fA-F]{1,4}){1,7}|:)
               |fe80:(:[0-9a-fA-F]{0,4}){0,4}%[0-9a-zA-Z]{1,}|::(ffff(:0{1,4}){0,1}:){0,1}((25[0-5]|(2[0-4]|1{0,1}[0-9])
               {0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])|([0-9a-fA-F]{1,4}:){1,4}:((25[0-5]|(2[0-4]|
               1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9]))/
