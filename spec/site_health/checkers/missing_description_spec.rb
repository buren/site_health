# frozen_string_literal: true

require 'spec_helper'

require 'site_health/checkers/missing_description'

RSpec.describe SiteHealth::MissingDescription do
  describe '#call' do
    it 'adds no issues if description is present and "correct"' do
      page = mock_test_page('html/index.html')
      checker = described_class.new(page).call

      expect(checker.issues).to be_empty
    end

    it 'adds issue if description is missing' do
      page = mock_test_page('html/missing_description.html')
      checker = described_class.new(page).call

      expect(checker.issues.first&.title).to eq('description missing')
    end

    it 'adds issue with correct priority if description is missing' do
      page = mock_test_page('html/missing_description.html')
      checker = described_class.new(page).call

      expect(checker.issues.first&.priority).to eq(:high)
    end

    it 'adds issue with correct severity if description is missing' do
      page = mock_test_page('html/missing_description.html')
      checker = described_class.new(page).call

      expect(checker.issues.first&.severity).to eq(:medium)
    end

    it 'adds issue if description is present, but empty' do
      page = mock_test_page('html/empty_description.html')
      checker = described_class.new(page).call

      expect(checker.issues.first&.title).to eq('description missing')
    end
  end

  describe '#name' do
    it 'returns missing_description' do
      expect(described_class.new(nil_page).name).to eq('missing_description')
    end
  end

  describe '#types' do
    it 'returns [:html]' do
      expect(described_class.new(nil_page).types).to eq([:html])
    end
  end
end
