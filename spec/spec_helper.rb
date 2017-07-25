require 'rspec'
require 'fileutils'
require_relative '../lib/imports/constants_and_requires'
require 'webmock/rspec'
require'vcr'


WebMock.disable_net_connect!

VCR.configure do |config|
  config.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  config.hook_into :webmock
end

RSpec.configure do |config|
  config.after(:each) do
    File.truncate(SITES_TO_CHECK_PATH, 0)
    File.truncate(FILE_FLAG_FILE_PATH , 0)
  end

  ### Silence stdout during tests ###
  original_stderr = $stderr
  original_stdout = $stdout
  config.before(:all) do
    # Redirect stderr and stdout
    $stderr = File.open(File::NULL, "w")
    $stdout = File.open(File::NULL, "w")
  end
  config.after(:all) do
    $stderr = original_stderr
    $stdout = original_stdout
  end

end
