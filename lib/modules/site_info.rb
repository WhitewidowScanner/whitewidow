# Capture information on the site that is available through the SQL
module SiteInfo

  # @param [String] site
  # Get the IP address that the site resolves to using Socket
  def capture_ip(site)
    uri = URI.parse(site)
    true_url = uri.hostname
    IPSocket::getaddress(true_url)
  end

  # @param [String] site
  # Get the site host name using Net::HTTP
  def capture_host(site)
    uri = URI.parse(site)
    res = Net::HTTP.get_response(uri)
    res['server'] # Pull it from the hash
  end

end