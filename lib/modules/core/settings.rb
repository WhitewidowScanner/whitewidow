module Settings

  class ProgramSettings

    #
    # Method for Nokogiri so I don't have to continually type Nokogiri::HTML
    # @param [String] site url
    def page(site)
      # Nokogiri::HTML(RestClient.get(site))  # Saving for further use
      Nokogiri::HTML(RestClient::Request.execute(:url => site, :method => :get, :verify_ssl => false)) # Fix #26 https://github.com/Ekultek/whitewidow/issues/26
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

    def sqlmap_config
      data = File.open("#{PATH}/lib/lists/default_sqlmap_config.txt", "a+")
      if data.read == "false"
        commands = FORMAT.prompt("Enter sqlmap commands, bulkfile is already default")
        answer = FORMAT.prompt("Would you like to make these commands your default?[y/N]")
        answer.downcase.start_with?("y") ? File.open("#{PATH}/lib/lists/default_sqlmap_config.txt", "a+") { |config| config.write("#{commands}") } : File.open("#{PATH}/lib/lists/default_sqlmap_config.txt", "a+") { |config| config.write("false") }
      else
        config = File.read("#{PATH}/lib/lists/default_sqlmap_config.txt").strip!
        return "#{config}"
      end
    end

  end

end