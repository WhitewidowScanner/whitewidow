#require_relative '../../lib/imports/constants_and_requires'

#
# sqlmap configuration, figure out if you have python installed or not
#
class SqlmapConfigHelper

  #
  # Python isn't real... It's just a conspiracy to make people believe they're hackers..
  #
  class PythonNotImplementedException < NotImplementedError
  end

  class << self

    def verify_operating_system
      data = RUBY_PLATFORM
      if data[/cygwin|mswin|mingw|bccwin|wince|emx/]
        true
      else
        false
      end
    end

    def find_python_env_var_windows
      py_path = [] # Results of the python env variables
      env_vars = ENV.to_h
      items = env_vars.to_s.split(/[^a-zA-Z0-9\/\\]/) # Split the environment variables into an array
      items.each { |var|
        if var.include?('Python')
          py_path.push(var)
        end
      }
      py_path.each { |python|
        if python.include?('2.7')
          return true
        elsif python.include?('3')
          return false
        else
          raise PythonNotImplementedException("Python must be installed before you can run sqlmap!") #Go here: #{PYTHON_DOWNLOAD_LINK}")
        end
      }
    end

    def find_python_version_linux
      version_string = system('python', '--version')
      if version_string.to_s.include?('2.7')
        return true
      elsif version_string.to_s.include?('3')
        return false
      else
        raise PythonNotImplementedException("Python must be installed before you can run sqlmap!") #Go here: #{PYTHON_DOWNLOAD_LINK}"
      end
    end

    def decisions_decisions
      if !(verify_operating_system)
        find_python_version_linux
      else
        find_python_env_var_windows
      end
    end

    def create_var_path
      if verify_operating_system
        ENV['python27'] = 'C:\\Python27'
      else
        ENV['python27'] = 'usr/local/bin'
      end
    end

  end

end

SqlmapConfigHelper.decisions_decisions