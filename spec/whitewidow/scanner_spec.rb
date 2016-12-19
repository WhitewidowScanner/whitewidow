require 'spec_helper'

describe Whitewidow::Scanner do
  describe 'usage_page' do
    subject { described_class.usage_page }
    it 'displays usage info' do
      expect{subject}.to output(/ruby/).to_stdout
    end

    it 'displays a reference to the README' do
      expect{subject}.to output(/README/).to_stdout
    end

  end

  describe 'format_file' do
    let(:test_website) { 'http://fakesite.com/' }
    let(:filename) { "asdf.txt" }
    subject { described_class.format_file(filename) }

    context 'when the file exists' do

      before { File.open(filename, 'w') { |file| file.puts test_website} }
      after { FileUtils.rm(filename) }

      it 'creates a properly formatted #sites.txt file' do
        expect { subject }.to output(/formatted/).to_stdout
        expect(IO.read("#{PATH}/tmp/#sites.txt")).to eq("#{test_website}\n")
      end
    end

    context 'when the file does not exist' do
      it 'displays an error' do
        begin
        expect{ subject }.to output("Don't worry I'll wait!").to_stdout
        expect { subject }.to raise_error(SystemExit)
        rescue SystemExit # Prevent exit() call from exiting tests
        end
      end
    end
  end

  describe 'get_urls' do
    subject { described_class.get_urls }
    # Ensure we search for the same query every time
    before { stub_const('DEFAULT_SEARCH_QUERY', 'user_id=') }
    let(:results) { File.readlines(SITES_TO_CHECK_PATH).map(&:strip) }
    it 'returns the correct data' do
      VCR.use_cassette('google_search') do
        subject
        expect(results.first).to eq("https://msdn.microsoft.com/en-us/library/ms181466.aspx'")
        expect(results.last).to eq('http://www.authorcode.com/user_id-and-user_name-in-sql-server/`')
      end
    end
  end
end
