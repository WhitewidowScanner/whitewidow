# Credits of the program
module Credits

  # Outputs the version number and credits to myself because I'm an arrogant fuck head.
  def credits
    puts 'Program created and written by: '.blue + "Ekultek".green.bold
    puts 'Current version: '.blue + VERSION.green.bold + '(' + VERSION_TYPE + ')'
  end

end
