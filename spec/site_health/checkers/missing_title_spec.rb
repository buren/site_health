# frozen_string_literal: true

require 'spec_helper'

require 'site_health/checkers/missing_title'

RSpec.describe SiteHealth::MissingTitle do
  describe '#call' do
    it 'adds no issue if title is present' do
      page = mock_test_page('html/index.html')
      checker = described_class.new(page).call

      expect(checker.issues).to be_empty
    end

    it 'adds issue if title is missing' do
      page = mock_test_page('html/missing_title.html')
      checker = described_class.new(page).call

      expect(checker.issues.first.title).to eq('title missing')
    end

    it 'adds issue if title is present, but empty' do
      page = mock_test_page('html/empty_title.html')
      checker = described_class.new(page).call

      expect(checker.issues.first.title).to eq('title missing')
    end
  end

  describe '#name' do
    it 'returns missing_title' do
      expect(described_class.new(nil_page).name).to eq('missing_title')
    end
  end

  describe '#types' do
    it 'returns [:html]' do
      expect(described_class.new(nil_page).types).to eq([:html])
    end
  end
end
