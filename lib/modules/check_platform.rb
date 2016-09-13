#
# Create a beep when this is used
#
module Platform

  class CheckBeep

    def Platform.windows?
      (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM) != nil
    end

    def Platform.mac?
      (/darwin/ =~ RUBY_PLATFORM) != nil
    end

    def Platform.unix?
      !OS.windows?
    end

    def Platform.linux?
      OS.unix? and not OS.mac?
    end

    def check_platform
      if Platform.windows?
        print "\a"
      elsif Platform.mac?
        system('say "beep"')
      elsif Platform.unix?
        system('echo -e "\a"')
      else
        system('echo -e "\a"')
      end
    end

  end

end