require_relative '../../lib/imports/constants_and_requires'

#
# sqlmap configuration, figure out if you have python installed or not
#
class SqlmapConfigHelper

  class << self

    def find_python_env_var
      py_path = []  # Results of the python env variables
      env_vars = ENV.to_h
      items = env_vars["Path"].split(";")  # Split the environment variables into an array
      items.each { |var|
        if var.to_s.include?("Python")  # Do you have python?
          py_path.push(var)
        end
      }
      py_path.each { |python|
        if python.include?("Python27")  # Python 2.7.x?
          return true
        elsif python.include?("Python3")  # Python 3.x.x?
          return false
        else
          raise "You do not have python installed, you can't run sqlmap without Python! Go here: #{PYTHON_DOWNLOAD_LINK}"
        end
      }
    end

  end

end