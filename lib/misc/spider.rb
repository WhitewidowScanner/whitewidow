# The opening, this will output every time the program is run unless you specify otherwise.
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
           _END_
               .cyan
    end

    # The version the program is currently in
    def version
      '1.5.01' # Version number
    end

  end

end
