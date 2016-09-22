module Copy

  # Copy from file to file instead of using the IO steam method.
  # @param [String] from_file
  # @param [String] to_file
  def file(from_file, to_file)
    File.open(from_file, "a+").each_line do |copy|
      File.open(to_file, "a+") { |vul| vul.puts(copy) }
    end
  end

end
