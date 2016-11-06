#
# Color code the output by serverity of issue
#
module Format

  class StringFormat

    # Yellow is a warning, something happened that shouldn't have
    def warning(input)
      puts "[#{Time.now.strftime("%T").purple} " + "WARNING".yellow + "] " + "#{input.yellow}"
    end

    # Prompt for information when there's a dry run done
    def prompt(input)
      print "#{input}: ".yellow
      STDIN.gets.chomp
    end

    # Red is a bad thing, this particular instance will kill the program
    def fatal(input)
      puts "[#{Time.now.strftime("%T").purple} " + "FATAL".red.bold + "] " + "#{input.red.bold}"
    end

    # Red is still bad, this is an error, usually means the site didn't load or doesn't exist
    def err(input)
      puts "[#{Time.now.strftime("%T").purple} " + "ERROR".red + "] " + "#{input.red}"
    end

    # Green is good, basic information, saying "hey, this is what's happening and why"
    def info(input)
      puts "[#{Time.now.strftime("%T").purple} " + "INFO".green + "] " + "#{input.green.bold}"
    end

    # Tells you that something worked successfully
    def success(input)
      puts "[#{Time.now.strftime("%T").purple} " + "SUCCESS" + "] " + "#{input.white}"
    end

    # Throws the valuable information that you will need, this is very good. Provides the IP and server info of the site
    def site_found(input)
      BEEP.check_platform if OPTIONS[:beep]  # TODO: When a IPv6 is thrown, resolve the IPv6 and give further info
      success = 'Possible Vulnerability'
      puts <<-_END_
    [ x ] -----------------------------------------------

    [#{Time.now.strftime("%T")} #{success}]

    [ X ]    Injection Point       :: #{input.cyan}
    [ X ]    Server Specifications :: #{SiteInfo.capture_host(input).cyan}
    [ X ]    Possible IP Address   :: #{SiteInfo.capture_ip(input).cyan}

      _END_
    end

  end

end