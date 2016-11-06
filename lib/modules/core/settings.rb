module Settings

  class ProgramSettings

    #
    # Method for Nokogiri so I don't have to continually type Nokogiri::HTML
    # @param [String] site url
    def page(site)
      Nokogiri::HTML(RestClient.get(site))
    end

#
# This is actually pretty smart, it's used to parse the HTML
# @param [String] site url
# @param [String] tag css selector
# @param [Integer] i the given html row
    def parse(site, tag, i)
      parsing = page(site)
      parsing.css(tag)[i].to_s
    end

  end

end