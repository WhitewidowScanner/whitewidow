module AdvancedDecoding
  def advanced_url_decoding
    IO.read("#{PATH}/log/non_exploitable.txt").each_line do |scan|
      if URI.decode(scan) == scan
        next
      else
        URI.decode_www_form(scan, UTF8)
        File.open("#{PATH}/tmp/multi_encoding_check.txt", 'a+') { |s| s.puts("#{scan.chomp}") }
      end
    end
  end
end