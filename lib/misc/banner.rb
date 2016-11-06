# The opening, this will output every time the program is run unless you specify otherwise.

require_relative '../../lib/modules/core/settings'

include Settings

module Whitewidow

  class Misc

    def spider
      puts <<-_END_
   __      __.__    .__  __         __      __.__    .___
  /  \\    /  \\  |__ |__|/  |_  ____/  \\    /  \\__| __| _/______  _  __
  \\   \\/\\/   /  |  \\|  \\   __\\/ __ \\   \\/\\/   /  |/ __ |/  _ \\ \\/ \\/ /
   \\        /|   Y  \\  ||  | \\  ___/\\        /|  / /_/ (  <_> )     /
    \\__/\\  / |___|  /__||__|  \\___  >\\__/\\  / |__\____ | \\____/ \\/\\_/
         \\/       \\/              \\/      \\/           \\/

  https://github.com/ekultek/whitewiow.git
  #{VERSION_STRING}
           _END_
               .cyan
    end

    # The version the program is currently in
    def version
      '1.5.1.4' # Version number <major>.<minor>.<patch>.<monthly commit>
    end
=begin
    def page(site)
      Nokogiri::HTML(RestClient.get(site))
    end
    # Deprecated, left for backup
    def parse(site, tag, i)
      parsing = page(site)
      parsing.css(tag)[i].to_s
    end
=end
    #
    # The type of version you have, usually it'll be stable or dev
    #
    def version_type(version)
      data = Settings::ProgramSettings.new.parse("https://github.com/Ekultek/whitewidow/blob/master/lib/misc/banner.rb", "td", 39)
      arr = data.split(" ")
      version_number = arr[7][/(\d+\.)?(\d+\.)?(\d+\.)?(\*|\d+)/]
      if version_number != version
        return "Upgrade Available".red.bold
      elsif version.length != 3
        return "dev".yellow.bold
      else
        return "stable".green.bold
      end
    end

  end

end
