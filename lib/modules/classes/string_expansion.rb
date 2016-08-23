class String

  #
  # Colorize the output passed through the program
  #
  def colorize(color_code)
    "\e[#{color_code}m#{self}\e[0m"
  end

  #
  # red is bad
  #
  def red
    colorize(31)
  end

  #
  # Green is good
  #
  def green
    colorize(32)
  end

  #
  # Cyan used for prompts
  #
  def cyan
    colorize(36)
  end

  #
  # Yellow used for warnings
  #
  def yellow
    colorize(33)
  end

  #
  # Purple used for time keeping
  #
  def purple
    colorize(35)
  end

  def blue
    colorize(34)
  end

end
