module MultipleParameters

  class TestAllParameters

    def check_for_multiple_parameters(site, syntax)
      if site.scan("=") != 1
        site.gsub!("=", "=" + syntax)
      end
    end

  end

end


##
# Test
#
#test = MultipleParameters::TestAllParameters.new
#test.check_for_multiple_parameters("http://multiplexstimulator.com/catalog/product.php?cat_id=82&pid=157&view=print", "`")
