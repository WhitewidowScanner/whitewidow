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
require_relative '../../lib/modules/detection'

# Modules that need to be included
include MultipleParameters
include Format
include Credits
include Legal
include Whitewidow
include Copy
include SiteInfo

# Constants used throughout the program
@vuln_found = 0
MULTIPARAMS = MultipleParameters::TestAllParameters.new
FORMAT = Format::StringFormat.new
PATH = Dir.pwd
VERSION = Whitewidow::Misc.new.version
SEARCH = File.readlines("#{PATH}/lib/lists/search_query.txt").sample
agents = YAML.load_file("#{PATH}/lib/lists/rand-age.yml")
OPTIONS = {}
USER_AGENT = agents[rand(1..20)]
SKIP = %w(stackoverflow.com github.com www.sa-k.net yoursearch.me search1.speedbit.com duckfm.net
          search.clearch.org webcache.googleusercontent.com m.facebook.com youtube.com)
LOADING_ERRORS = [RestClient::ResourceNotFound, RestClient::InternalServerError, RestClient::RequestTimeout,
                  RestClient::Gone, RestClient::SSLCertificateNotVerified, RestClient::Forbidden,
                  OpenSSL::SSL::SSLError, Errno::ECONNREFUSED, URI::InvalidURIError, Errno::ECONNRESET,
                  Timeout::Error, OpenSSL::SSL::SSLError, Zlib::GzipFile::Error, RestClient::MultipleChoices,
                  RestClient::Unauthorized, SocketError, RestClient::BadRequest, RestClient::ServerBrokeConnection,
                  Errno::ECONNABORTED, Zlib::BufError]
FATAL_ERRORS = [Mechanize::ResponseCodeError, RestClient::ServiceUnavailable, OpenSSL::SSL::SSLError,
                RestClient::BadGateway, Errno::ENETUNREACH, Net::HTTP::Persistent::Error,
                Errno::ETIMEDOUT]
