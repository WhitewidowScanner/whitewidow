#
# Scan the URL for multiple parameters
#
module MultipleParameters

  class TestAllParameters

    # Add if multiple parameters are found
    # @param [String] site to check for
    # @param [Syntax] SQL syntax to inject
    def check_for_multiple_parameters(site, syntax)
      if site.scan("=").count != 1
        site.sub!("=", "=" + syntax)
      end
    end

  end

end