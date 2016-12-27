require 'spec_helper'

describe FileHelper do
  describe 'open_or_create' do
    subject { File.open(FileHelper.open_or_create(filename)) }
    after { FileUtils.rm_f(filename) }  # Force the removal

    context 'when the file exists' do
      let(:filename) { 'testing_file' }
      before { FileUtils.touch(filename) }

      it 'returns the filename and the file can be opened' do
        expect{ subject }.to_not raise_error
      end
    end

    context 'when the file does not exist' do
      let(:filename) { File.join('tmp', 'test_directory', 'test_file') }

      it 'creates the file and the file can be opened' do
        expect{ File.open(filename) }.to raise_error
        expect{ subject }.to_not raise_error
      end
    end
  end
end
