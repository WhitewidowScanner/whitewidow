module Copy

  # Copy from file to file instead of using the IO steam method.
  # @param [String] file1
  # @param [String] file2
  def file(file1, file2)
    File.open(file1, "a+").each_line do |s|
      File.open(file2, "a+") { |vul| vul.puts(s) }
    end
  end

end
