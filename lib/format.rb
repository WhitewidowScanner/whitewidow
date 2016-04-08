module Format
  def warning(input)
    puts "[#{Time.now.strftime("%T")} WARNING]#{input}".yellow.bold
  end

  def fatal(input)
    puts "[#{Time.now.strftime("%T")} FATAL]#{input}".red.bold
  end

  def err(input)
    puts "[#{Time.now.strftime("%T")} ERROR]#{input}".red.bold
  end

  def info(input)
    puts "[#{Time.now.strftime("%T")} INFO]#{input}".green.bold
  end

  def success(input)
    puts "[#{Time.now.strftime("%T")} SUCCESS]#{input}".white.bold
  end

  def usage(input)
    puts
    puts "[USAGE]#{input}".white.bold
    puts
  end
end