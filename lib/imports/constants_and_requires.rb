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
require_relative '../../lib/modules/format'
require_relative '../../lib/misc/credits'
require_relative '../../lib/misc/legal'
require_relative '../../lib/misc/spider'
require_relative '../../lib/modules/copy'
require_relative '../../lib/modules/site_info'

include Format
include Credits
include Legal
include Whitewidow
include Copy
include SiteInfo

PATH = Dir.pwd
VERSION = Whitewidow.version
SEARCH = File.readlines("#{PATH}/lib/lists/search_query.txt").sample
info = YAML.load_file("#{PATH}/lib/lists/rand-agents.yaml")
@user_agent = info['user_agents'][info.keys.sample]
OPTIONS = {}