module Format
  def warning(input)
    t = Time.now
    puts "[#{t.hour}:#{t.min}:#{t.sec} WARNING]#{input}".yellow.bold
  end

  def fatal(input)
    t = Time.now
    puts "[#{t.hour}:#{t.min}:#{t.sec} FATAL]#{input}".red.bold
  end

  def err(input)
    t = Time.now
    puts "[#{t.hour}:#{t.min}:#{t.sec} ERROR]#{input}".red.bold
  end

  def info(input)
    t = Time.now
    puts "[#{t.hour}:#{t.min}:#{t.sec} INFO]#{input}".green.bold
  end

  def success(input)
    t = Time.now
    puts "[#{t.hour}:#{t.min}:#{t.sec} SUCCESS]#{input}".white.bold
  end

  def usage(input)
    puts
    puts "[USAGE]#{input}".white.bold
    puts
  end
end