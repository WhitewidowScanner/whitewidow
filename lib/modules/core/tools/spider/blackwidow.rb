require_relative '../../../../../lib/modules/core/settings'

include Settings

#
# Recursive spider search, runs through all the urls and grabs that sites urls
#
module BlackWidow

  class RecursiveSpider

    #
    # Extracts all the links from a url
    #
    def pull_links(url)
      data = Settings::ProgramSettings.new.parse(url, 'html', 0)
      return URI.extract(data, ['http', 'https'])
    end

    #
    # Extracts the links from the links that were extracted making even more links, it's pretty sexy..
    #
    def follow_links(url_arr)
      url_arr.each do |link|
        search = Settings::ProgramSettings.new.parse(link, 'html', 0)
        data = URI.extract(search, %w(http https))
        data.each do |url|
          FORMAT.info("Found #{url}")
          File.open("#{PATH}/tmp/blackwidow_log.txt", "a+") { |to_search| to_search.write(url + "\n") }
          sleep(0.2)
        end
      end
    end

  end

end
