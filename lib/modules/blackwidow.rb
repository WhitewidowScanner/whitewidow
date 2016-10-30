# Recursive spider search, runs through all the urls and grabs that sites urls

module BlackWidow

  class RecursiveSpider

    def pull_links(url)
      # Extract all the urls and throw them into an array
      data = parse(url, 'html', 0)
      return URI.extract(data, ['http', 'https'])
    end

    def follow_links(url_arr)
      # Do the same thing with the url array
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