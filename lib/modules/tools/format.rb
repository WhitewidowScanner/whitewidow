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

  def prompt(input)
    print "[#{Time.now.strftime("%T")}] #{input} ".white.bold
    gets.chomp.upcase
  end

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

  def usage(input)
    puts
    puts "[USAGE]#{input}".white.bold
    puts
  end
end