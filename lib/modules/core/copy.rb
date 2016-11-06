module Copy

  #
  # Copy from one file to another
  #
  def file(from_file, to_file)
    File.open(from_file, "a+").each_line do |copy|
      File.open(to_file, "a+") { |vul| vul.puts(copy) }  # TODO: Copy with IO.copy_stream instead
    end
  end

end
