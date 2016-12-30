require 'csv'
require 'ipaddr'

#
# Find the country the IP address originates from
#
class IPFilter

  class << self

    def find_country_by_ip_address(ip_address)
      ip = IPAddr.new(ip_address).to_i
      CSV.foreach('GeoIPCountry.csv') do |_, _, ip1, ip2, _, country_name|
        return country_name if (ip1.to_i..ip2.to_i).cover?(ip)  # Return what country the IP originates from by checking the IP range
      end
    end

  end

end

puts IPFilter.find_country_by_ip_address('1.5.255.200')