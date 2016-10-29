# Recursive spider search, runs through all the urls and grabs that sites urls

module BlackWidow

  class RecursiveSpider

    def initialize(url)
      @url = url
    end

    def pull_links
      # Extract all the urls and throw them into an array
      data = parse(@url, 'html', 0)
      return URI.extract(data, ['http', 'https'])
    end

    def follow_links(urls)
      # Do the same thing with the url array
      urls.each do |link|
        search = parse(link, 'html', 0)
        data = URI.extract(search, %w(http https))
        data.each do |url|
          FORMAT.info("Found #{url}.")
          File.open("#{PATH}/log/blackwidow_log.txt", "a+") { |to_search| to_search.write(url) }
          sleep(1)
        end
      end
    end

  end

end