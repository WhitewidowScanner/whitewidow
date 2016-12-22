require 'spec_helper'

describe Whitewidow::Scanner do
  describe 'format_file' do  # Test file formatting
    let(:test_website) { 'http://fakesite.com/' }
    let(:filename) { "asdf.txt" }
    subject { described_class.format_file(filename) }

    context 'when the file exists' do

      before { File.open(filename, 'w') { |file| file.puts test_website} }
      after { FileUtils.rm(filename) }

      it 'creates a properly formatted #sites.txt file' do
        expect { subject }.to output(/formatted/).to_stdout
        expect(IO.read(FILE_FLAG_FILE_PATH)).to eq("#{test_website}\n")
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

  describe 'get_urls' do  # Test get_urls method
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

  shared_examples_for 'a non-exploitable site' do
    let(:filename) { NON_EXPLOITABLE_PATH }

    it 'adds the site to the not_exploitable list' do
      subject
      expect(File.readlines(filename).map(&:strip)).to eq([test_website])
    end
  end

  describe 'vulnerability_check' do  # Test the vulnerability check
    let(:test_website) { 'http://fakesite.com/' }
    subject { described_class.vulnerability_check(file_mode: true) }

    before do
      File.open(FILE_FLAG_FILE_PATH, 'w+') { |file| file.puts test_website }
      allow(SETTINGS).to receive(:parse).and_return(response)
      allow(FORMAT).to receive(:site_found)
    end

    after { File.truncate(filename, 0) }

    context 'when a site is vulnerable' do
      let(:filename) { TEMP_VULN_LOG }
      let(:response) { 'SQL query error' }
      it 'adds the site to the vulnerable list' do
        subject
        expect(File.readlines(filename).map(&:strip)).to eq([test_website])
      end
    end

    context 'when a site is not vulnerable' do
      let (:response) { 'some html' }
      it_behaves_like 'a non-exploitable site'
    end

    context 'when a site times out' do
      let(:response) { Timeout::Error }
      it_behaves_like 'a non-exploitable site'
    end

    context 'when an SSL error occurs' do
      let(:response) { OpenSSL::SSL::SSLError }
      it_behaves_like 'a non-exploitable site'
    end

  end

end
