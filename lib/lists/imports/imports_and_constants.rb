require 'rubygems'
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

require_relative '../../../lib/classes/credits'
require_relative '../../../lib/classes/legal'
require_relative '../../../lib/classes/spider'
require_relative '../../../lib/classes/site_info'
require_relative '../../../lib/classes/tools/blackwidow'
require_relative '../../../lib/classes/tools/format'
require_relative '../../../lib/classes/tools/copy'

include Format
include Credits
include Legal
include Whitewidow
include Copy
include SiteInfo
include BlackWidow

PATH = Dir.pwd
VERSION = Whitewidow.version
SEARCH = File.readlines("#{PATH}/lib/search_query.txt").sample
OPTIONS = {}