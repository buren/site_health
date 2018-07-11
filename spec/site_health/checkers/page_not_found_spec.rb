# frozen_string_literal: true

require 'spec_helper'

require 'site_health/checkers/page_not_found'

RSpec.describe SiteHealth::PageNotFound do
  describe '#call' do
    it 'returns false if page is present' do
      page = mock_test_page('html/index.html')
      checker = described_class.new(page).call

      expect(checker.data[:not_found]).to eq(false)
    end

    it 'returns true if page is missing' do
      page = mock_test_page('html/this_file_must_never_exist.html')
      checker = described_class.new(page).call

      expect(checker.data[:not_found]).to eq(true)
    end
  end

  describe '#name' do
    it 'returns page_not_found' do
      expect(described_class.new(nil_page).name).to eq('page_not_found')
    end
  end

  describe '#types' do
    it 'returns all checkable types' do
      checkable_types = SiteHealth::Checker::CHECKABLE_TYPES
      expect(described_class.new(nil_page).types).to eq(checkable_types)
    end
  end
end
