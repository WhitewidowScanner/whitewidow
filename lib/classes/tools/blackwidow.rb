module BlackWidow
  def grab_urls

  end

  def connect_to_urls

  end

  def file(info)
    File.open('log/blackwidow_results.txt', 'a+') { |s| s.puts(info) }
  end
end