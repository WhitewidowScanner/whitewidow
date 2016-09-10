# Color format the output of the program based on severity of the issue
require_relative "../../lib/modules/expansion/string_expan"

module Format

  class StringFormat

    # @param [String] *args
    # Yellow is a warning
    def warning(input)
      puts "[#{Time.now.strftime("%T").purple} WARNING] #{input.yellow}"
    end

    # Red is a bad thing, this particular instance will kill the program
    def fatal(input)
      puts "[#{Time.now.strftime("%T").purple} FATAL] #{input.red.bold}"
    end

    # Red is still bad
    def err(input)
      puts "[#{Time.now.strftime("%T").purple} ERROR] #{input.red}"
    end

    # Green is good
    def info(input)
      puts "[#{Time.now.strftime("%T").purple} INFO] #{input.green.bold}"
    end

    # Found a site wooohooo
    def success(input)
      puts "[#{Time.now.strftime("%T").purple} SUCCESS] #{input.white}"
    end

    # Throws the valuable information that you will need, this is very good.
    def site_found(input)

      success = 'Possible Vulnerability'
      puts <<-_END_
    [ x ] -----------------------------------------------

    [#{Time.now.strftime("%T")} #{success}]

    [ X ]    Injection Point       :: #{input}
    [ X ]    Server Specifications :: #{SiteInfo.capture_host(input)}
    [ X ]    Possible IP Address   :: #{SiteInfo.capture_ip(input)}

      _END_
    end

    # And a normal usage page
    def usage(input)
      puts
      puts "[USAGE]#{input}"
      puts
    end

  end

end

=begin
##
# Testing
#
test = Format::StringFormat.new
test.err("test")
test.info("test")
test.warning("test")
test.fatal("test")
=end