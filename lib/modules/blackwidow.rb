#
# Recursive spider search, runs through all the urls and grabs that sites urls
#
module BlackWidow

  class RecursiveSpider

    #
    # Extracts all the links from a url
    #
    def pull_links(url)
      data = parse(url, 'html', 0)
      return URI.extract(data, ['http', 'https'])
    end

    #
    # Extract the links from that URL as well and save them into a file
    #
    def follow_links(url_arr)
      url_arr.each do |link|
        search = parse(link, 'html', 0)
        data = URI.extract(search, %w(http https))
        data.each do |url|
          FORMAT.info("Found #{url}.")
          File.open("#{PATH}/tmp/blackwidow_log.txt", "a+") { |to_search| to_search.write(url + "\n") }
          sleep(1)
        end
      end
    end

  end

end