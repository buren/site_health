# frozen_string_literal: true

require 'spec_helper'

require 'site_health/checkers/html_proofer'

RSpec.describe SiteHealth::HTMLProofer do
  describe '#call' do
    it "returns no failures for 'perfect' page" do
      page = mock_test_page('html/perfect.html')
      checker = described_class.new(page).call

      expect(checker.data[:errors]).to eq([])
    end

    it 'returns missing favicon failure' do
      page = mock_test_page('html/missing_favicon.html')
      checker = described_class.new(page).call

      expect(checker.data[:errors]).to eq(['no favicon specified'])
    end

    it 'returns missing favicon failure' do
      page = mock_test_page('html/missing_image_alt.html')
      checker = described_class.new(page).call

      expect(checker.data[:errors].first).to match('does not have an alt attribute')
    end

    it 'returns bad link failure' do
      page = mock_test_page('html/single_bad_link.html')
      checker = described_class.new(page).call

      expect(checker.data[:errors].first).to match('is an invalid URL')
    end

    it 'returns bad HTML-syntax' do
      page = mock_test_page('html/bad_syntax.html')
      checker = described_class.new(page).call

      expect(checker.data[:errors].first).to match('ERROR: error parsing attribute name')
    end
  end

  describe '#name' do
    it 'returns html_proofer' do
      expect(described_class.new(nil_page).name).to eq('html_proofer')
    end
  end

  describe '#types' do
    it 'returns [:html]' do
      expect(described_class.new(nil_page).types).to eq([:html])
    end
  end

  describe '#tempfile' do
    it 'yields tempfile to passed block' do
      file_content = 'file content'

      described_class.new(nil_page).tempfile(file_content) do |file|
        expect(File.read(file.path)).to eq(file_content)
      end
    end

    it 'has .html file extension' do
      described_class.new(nil_page).tempfile('') do |file|
        expect(file.path.end_with?('.html')).to eq(true)
      end
    end

    it 'removes tempfile after yield' do
      file_content = 'file content'
      path = nil

      described_class.new(nil_page).tempfile(file_content) do |file|
        path = file.path
      end

      expect do
        File.read(path)
      end.to raise_error(Errno::ENOENT)
    end
  end
end
