# The opening, this will output every time the program is run.
module Whitewidow

  class Credits

    # Spider, big fancy spider thingy
    def spider
      puts <<-_END_
##     ##    ##     ##
##  #  ##    ##  #  ##
## # # ##    ## # # ##
###   ###    ###   ###
##     ## #  ##     ## #
      _END_
    end

    # The version the program is currently in
    def version
      '1.0.6.3' # Version number
    end

    # Credits for the program
    def credits
      print 'Credits to my creator: ', "Ekultek, he's a beast!\n".blue,
            'I am currently version: ', "#{version}, stick around for upgrades!\n".blue,
            'My name is: ', "Whitewidow, that's right albino deadly spider\n".blue,
            puts
      puts
    end

  end

end