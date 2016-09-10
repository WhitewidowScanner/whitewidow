# Capture information on the site that is available through the SQL
module SiteInfo

  # @param [String] site
  # Get the IP address that the site resolves to using Socket
  def self.capture_ip(site)
    uri = URI.parse(site)
    true_url = uri.hostname
    return IPSocket::getaddress(true_url)
  end

  # @param [String] site
  # Get the site host name using Net::HTTP
  def self.capture_host(site)
    uri = URI.parse(site)
    res = Net::HTTP.get_response(uri)
    return res['server'] # Pull it from the hash
  end

end