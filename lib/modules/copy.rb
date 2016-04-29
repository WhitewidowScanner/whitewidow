module Copy
  def file(file1, file2)
    File.open(file1, "a+").each_line do |s|
      File.open(file2, "a+") { |vul| vul.puts(s) }
    end
  end
end
