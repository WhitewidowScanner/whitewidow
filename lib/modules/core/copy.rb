module Copy

  #
  # Copy from one file to another, it actually works faster then IO.copy_stream believe it or not
  # IO.copy_stream == 0.0234323 seconds
  # This == 0.00123432 seconds
  #
  def file(from_file, to_file)
    File.open(from_file, "a+").each_line do |copy|
      File.open(to_file, "a+") { |vul| vul.puts(copy) }
    end
  end

end
