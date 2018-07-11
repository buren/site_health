# frozen_string_literal: true

require 'spec_helper'

require 'site_health/checkers/w3c_html'

RSpec.describe SiteHealth::W3CHTML do
  describe '#call' do
    xit "returns no failures for 'perfect' page" do
      page = mock_test_page('html/perfect.html')
      result = described_class.new(page).call

      expect(result).to eq([])
    end
  end

  describe '#name' do
    it 'returns w3c_html' do
      expect(described_class.new(nil_page).name).to eq('w3c_html')
    end
  end

  describe '#types' do
    it 'returns [:html]' do
      expect(described_class.new(nil_page).types).to eq([:html])
    end
  end
end
