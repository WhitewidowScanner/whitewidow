require_relative '../../../../lib/imports/constants_and_requires'

#
# Find the country the IP address originates from
#
class IPFilter

  class << self

    def find_country_by_ip_address(ip_address)
      ip = IPAddr.new(ip_address).to_i
      CSV.foreach("#{PATH}/lib/lists/GeoIPCountry.csv") do |_, _, ip1, ip2, _, country_name|
        return country_name.to_s.cyan if (ip1.to_i..ip2.to_i).cover?(ip)  # Return what country the IP originates from by checking the IP range
      end
    end

  end

end
