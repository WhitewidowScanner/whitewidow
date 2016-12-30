# The opening, this will output every time the program is run unless you specify otherwise.

require_relative '../../lib/modules/core/settings'

include Settings

module Whitewidow

  class Misc

    def spider
      puts <<~_END_
   __      __.__    .__  __         __      __.__    .___
  /  \\    /  \\  |__ |__|/  |_  ____/  \\    /  \\__| __| _/______  _  __
  \\   \\/\\/   /  |  \\|  \\   __\\/ __ \\   \\/\\/   /  |/ __ |/  _ \\ \\/ \\/ /
   \\        /|   Y  \\  ||  | \\  ___/\\        /|  / /_/ (  <_> )     /
    \\__/\\  / |___|  /__||__|  \\___  >\\__/\\  / |__\____ | \\____/ \\/\\_/
         \\/       \\/              \\/      \\/           \\/    #{VERSION_STRING}

  #{REPO_LINK}
  #{DOWNLOAD_LINK}
  #{BASIC_LEGAL_DISCLAIMER}
           _END_
               .cyan.bold
    end

    # The version the program is currently in
    def version
      '1.9.9.20' # Version number <major-update>.<minor-update>.<patch-update>.<commit-count>
    end

    #
    # The type of version you have, usually it'll be stable or dev
    #
    def version_type(version)
      data = Settings::ProgramSettings.new.parse("https://github.com/Ekultek/whitewidow/blob/master/lib/misc/banner.rb", "td", 57)
      arr = data.split(" ")
      version_number = arr[7][/(\d+\.)?(\d+\.)?(\d+\.)?(\*|\d+)/]
      if version.count(".") == 2
        return "stable".green.bold
      elsif version.length != 3
        return "dev".yellow.bold
      elsif version != version_number
        return "upgrade available".red.bold
      else
        return "unknown version type".red.bold
      end

    end

  end

end
