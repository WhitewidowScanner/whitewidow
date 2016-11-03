#
# Scan the URL for multiple parameters
#
module MultipleParameters

  class TestAllParameters

    #
    # Add injection syntax for every "=" in the URL
    #
    def check_for_multiple_parameters(site, syntax)
      if site.scan("=").count != 1
        site.sub!("=", "=" + syntax)  # TODO: Add the syntax one at at a time and remove the last one added
      end
    end

  end

end
