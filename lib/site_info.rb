module SiteInfo

  def capture_ip(site)
    uri = URI.parse(site)
    true_url = uri.hostname
    IPSocket::getaddress(true_url)
  end

  def capture_host(site)
    uri = URI.parse(site)
    res = Net::HTTP.get_response(uri)
    res['server']
  end
end