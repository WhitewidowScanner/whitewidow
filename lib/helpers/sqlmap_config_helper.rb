class SqlmapConfigHelper

  class << self

    def find_python_env_var
      py_path = []
      env_vars = ENV.to_h
      items = env_vars["Path"].split(";")
      items.each { |var|
        if var.to_s.include?("Python")
          py_path.push(var)
        end
      }
      py_path.each { |python|
        if python.include?("Python27")
          return true
        elsif python.include?("Python3")
          return false
        else
          raise "You do not have python installed"
        end
      }
    end

  end

end