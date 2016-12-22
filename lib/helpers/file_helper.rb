# Allows files to be opened without having to write an explicit check to see if the file or directory exists
class FileHelper

  class << self

    def open_or_create(filename)
      unless File.exist?(filename)
        directory = directory_path(filename)
        create_directory(directory) unless directory_exists?(directory)
        create_file(filename)
      end
      filename
    end

    private

    def create_directory(dir)
      FileUtils.mkdir_p(dir)
    end

    def create_file(filename)
      FileUtils.touch(filename)
    end

    def directory_path(filename)
      File.dirname(filename)
    end

    def directory_exists?(dir)
      File.directory?(dir)
    end

  end

end
