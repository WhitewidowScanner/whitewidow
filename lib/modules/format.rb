# Color format the output of the program based on severity of the issue
module Format

  # @param [String] *args
  # Yellow is a warning
  def warning(input)
    puts "[#{Time.now.strftime("%T")} WARNING]#{input}".yellow.bold
  end

  # Red is a bad thing, this particular instance will kill the program
  def fatal(input)
    puts "[#{Time.now.strftime("%T")} FATAL]#{input}".red.bold
  end

  # Red is still bad
  def err(input)
    puts "[#{Time.now.strftime("%T")} ERROR]#{input}".red.bold
  end

  # Green is good
  def info(input)
    puts "[#{Time.now.strftime("%T")} INFO]#{input}".green.bold
  end

  # Found a site wooohooo
  def success(input)
    puts "[#{Time.now.strftime("%T")} SUCCESS]#{input}".white.bold
  end

  # Throws the valuable information that you will need, this is very good.
  def site_found(input)

    success = 'Possible Vulnerability'.green.bold
    puts <<-_END_
    [ x ] -----------------------------------------------

    [#{Time.now.strftime("%T").green.bold} #{success}]

    [ X ]    Injection Point       :: #{input.cyan.bold}
    [ X ]    Server Specifications :: #{SiteInfo.capture_host(input).cyan.bold}
    [ X ]    Possible IP Address   :: #{SiteInfo.capture_ip(input).cyan.bold}

            _END_
  end

  # And a normal usage page
  def usage(input)
    puts
    puts "[USAGE]#{input}".white.bold
    puts
  end

end