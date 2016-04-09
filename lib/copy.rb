module Copy
  def file
    File.open("#{PATH}/tmp/SQL_VULN.txt", "a+").each_line do |s|
      File.open("#{PATH}/log/SQL_VULN.LOG", "a+") { |vul| vul.puts(s) }
    end
  end
end
