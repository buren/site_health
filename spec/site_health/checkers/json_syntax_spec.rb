require "spec_helper"

require "site_health/checkers/json_syntax"

RSpec.describe SiteHealth::Checkers::JSONSyntax do
  describe "#call" do
    it "returns *no* error message if JSON is valid" do
      page = mock_test_page("json/good.json")
      result = described_class.new(page).call

      expect(result).to eq('OK')
    end

    it "returns error message if JSON is invalid" do
      page = mock_test_page("json/bad.json")
      result = described_class.new(page).call

      expect(result).to eq("765: unexpected token at '1'")
    end
  end

  describe "#name" do
    it "returns json_syntax" do
      expect(described_class.new(nil_page).name).to eq("json_syntax")
    end
  end

  describe "#types" do
    it "returns [:json]" do
      expect(described_class.new(nil_page).types).to eq([:json])
    end
  end
end
