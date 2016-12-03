#
# Pull the information of the site that is available. Pulls the server (apache, redhat, etc) and the IP address
# that the site resolves to
#
module SiteInfo

  #
  # Get the IP address that the site resolves to using Socket
  #
  def self.capture_ip(site)
    uri = URI.parse(site)
    true_url = uri.hostname
    ip = IPSocket::getaddress(true_url)
    if !(ip =~ /^(?=\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$)(?:(?:25[0-5]|[12][0-4][0-9]|1[5-9][0-9]|[1-9]?[0-9])\.?)
                {4}$|(?=^(?:[0-9a-f]{0,4}:){2,7}[0-9a-f]{0,4}$)(?![^:]*::.+::[^:]*$)(?:(?=.*::.*)|
                (?=\w+:\w+:\w+:\w+:\w+:\w+:\w+:\w+))(?:(?:^|:)(?:[0-9a-f]{4}|[1-9a-f][0-9a-f]{0,3})){0,8}
                (?:::(?:[0-9a-f]{1,4}(?:$|:)){0,6})?$/)
      return ip
    else
      if ip.ipv4_mapped
        return ip.native
      else
        return "Unknown".red.bold
      end
    end
  end

  #
  # Get the site host name using Net::HTTP
  #
  def self.capture_host(site)
    uri = URI.parse(site)
    res = Net::HTTP.get_response(uri)
    return res['server'] # Pull it from the hash that is created
  end

end