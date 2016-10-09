require 'mechanize'
require 'open-uri'
require 'uri'

module BlackWidow

  class RecursiveSpider

    def initialize(site)
      @site = site
    end

    def pull_urls
      URI.extract(open(@site).read).grep(/\w+:\/\/[\w.-]+(?::?\d{1,5})?[-\w.\/?=&%]*/).each do |link|
        File.open("blackwidow_links.txt", "a+") { |url| url.puts(link) }
      end
    end

    def follow_links
      File.open("blackwidow_links.txt", "r").each_line do |link|
        p URI.extract(open(link).read).grep(/\w+:\/\/[\w.-]+(?::?\d{1,5})?[-\w.\/?=&%]*/)
      end
    end

  end

end