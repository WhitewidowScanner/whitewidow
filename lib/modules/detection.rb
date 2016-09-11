#
# Scan the URL for multiple parameters
#
module MultipleParameters

  class TestAllParameters

    # Add if multiple parameters are found
    #
    # @param [String] site to check for
    def check_for_multiple_parameters(site, syntax)
      if site.scan("=") != 1
        site.gsub!("=", "=" + syntax)
      end
    end

  end

end