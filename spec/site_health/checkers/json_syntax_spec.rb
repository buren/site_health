# frozen_string_literal: true

require 'spec_helper'

require 'site_health/checkers/json_syntax'

RSpec.describe SiteHealth::JSONSyntax do
  describe '#call' do
    it 'returns *no* error message if JSON is valid' do
      page = mock_test_page('json/good.json')
      checker = described_class.new(page).call

      expect(checker.data[:parsing]).to eq('OK')
    end

    it 'returns error message if JSON is invalid' do
      page = mock_test_page('json/bad.json')
      checker = described_class.new(page).call

      expect(checker.data[:parsing]).to eq("765: unexpected token at '1'")
    end
  end

  describe '#name' do
    it 'returns json_syntax' do
      expect(described_class.new(nil_page).name).to eq('json_syntax')
    end
  end

  describe '#types' do
    it 'returns [:json]' do
      expect(described_class.new(nil_page).types).to eq([:json])
    end
  end
end
