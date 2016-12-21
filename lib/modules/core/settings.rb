module Settings

  class ProgramSettings

    #
    # Method for Nokogiri so I don't have to continually type Nokogiri::HTML
    # @param [String] site url
    def page(site)
      response = RestClient::Request.execute(:url => site, :method => :get, :verify_ssl => false) # Fix #26 https://github.com/Ekultek/whitewidow/issues/26
      response.force_encoding('iso-8859-1').encode('utf-8')  # Force the response into UTF-8
      Nokogiri::HTML(response)  # Pull the HTML from the UTF-8 encoded response
    end

    #
    # This is actually pretty smart, it's used to parse the HTML and pull from css selectors
    #
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
    # Specify the download link for the user
    #
    def ruby_download_link
      if RUBY_PLATFORM =~ /linux/
        " running sudo apt-get install ruby-full"
      elsif RUBY_PLATFORM =~ /cygwin|mswin|mingw|bccwin|wince|emx/
        " going to this link: https://dl.bintray.com/oneclick/rubyinstaller/rubyinstaller-2.3.3.exe"
      else
        " going to this link: https://www.ruby-lang.org/en/documentation/installation/#package-management-systems"
      end  
    end
=begin  # Still working on this, temporarily in the main file
    #
    # Error based SQL injection
    #
    def add_error_based_sql_test(url)
      %w(' -- ; " /* '/* '-- "-- '; "; `).each { |error|
        File.open("#{SITES_TO_CHECK_PATH}", "a+") { |error_check| error_check.puts("#{url}#{error}") }
        MULTIPARAMS.check_for_multiple_parameters(url, error)
      }
    end

    #
    # Blind based SQL injection
    #
    def add_blind_based_sql_test(url)
      [" AND 1=1"].each { |blind|
        File.open("#{SITES_TO_CHECK_PATH}", "a+") { |blind_check| blind_check.puts("#{urls_to_log}#{blind}") }
      }
    end
=end
    #
    # Hide the banner if the banner flag is used
    #
    def hide_banner?
      if !(OPTIONS[:banner])
        Whitewidow::Misc.new.spider
      end
    end

    #
    # Show the legal and TOS if the legal flag is used
    #
    def show_legal?
      if OPTIONS[:legal]
        Legal::Legal.new.legal
      end
    end

    #
    # Customize your search queries if the dork flag is use
    #
    def extract_query!
      if !(OPTIONS[:dork])
        return DEFAULT_SEARCH_QUERY
      else
        return OPTIONS[:dork]
      end
    end

    #
    # Extract a random user agent if the user agent flag is used
    #
    def random_agent?
      if !(OPTIONS[:agent])
        return DEFAULT_USER_AGENT
      else
        return USER_AGENTS["rand_agents"][rand(1..102)]
      end
    end

    def update!
      system("git pull origin master")
    end

  end

end
