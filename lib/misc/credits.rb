# Credits of the program
module Credits

  # Outputs the version number and credits to myself because I'm an arrogant fuck head.
  def credits
     puts <<~_END_
     Program written and created by "Ekultek".
     Current version: #{VERSION} (#{VERSION_TYPE})
     _END_
    .blue.bold
  end

end
