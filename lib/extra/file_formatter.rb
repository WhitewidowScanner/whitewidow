path = Dir.pwd
file = "#{path}/#{ARGV[0]}"
if ARGV[0].nil?
  puts 'Move file into this directory and run file name as ARGV'
end

IO.read(file).each_line do |s|
  File.open('#sites.txt', 'a+') { |file| file.puts(s) unless s.chomp.empty? }
end

puts "File: #{file} is formatted correctly and has been moved to file: #sites.txt."
