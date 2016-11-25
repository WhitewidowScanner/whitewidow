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

    #
    # sqlmap configuration, will prompt you if you want to save the commands
    #
    def sqlmap_config
      data = File.open("#{PATH}/lib/lists/default_sqlmap_config.txt", "a+")
      if data.read == "false"
        commands = FORMAT.prompt("Enter sqlmap commands, bulkfile is already default")
        answer = FORMAT.prompt("Would you like to make these commands your default?[y/N]")
        if answer.downcase.start_with?("y")
          File.open("#{PATH}/lib/lists/default_sqlmap_config.txt", "w") { |config| config.write("#{commands}") }
        else
          File.open("#{PATH}/lib/lists/default_sqlmap_config.txt", "w") { |config| config.write("false") }
        end
      else
        config = File.read("#{PATH}/lib/lists/default_sqlmap_config.txt").strip!
        return "#{config}"
      end
    end

    #
    # Hide the banner?
    #
    def hide_banner?
      if !(OPTIONS[:banner])
        Whitewidow::Misc.new.spider
      end
    end

    #
    # Show the legal and TOS?
    #
    def show_legal?
      if OPTIONS[:legal]
        Legal::Legal.new.legal
      end
    end

=begin
      def obtain_Search_engine_link
        if OPTIONS[:se]
          return SEARCH_ENGINES[rand(1..3)]
        else
          return DEFAULT_SEARCH_ENGINE
        end
      end
=end

  end

end