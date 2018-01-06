require "spec_helper"

require "site_health/checkers/xml"

RSpec.describe SiteHealth::Checkers::XML do
  describe "#call" do
    it "returns *no* error message if XML is valid" do
      page = mock_test_page("xml/good.xml")
      result = described_class.new(page).call

      expect(result).to be_empty
    end

    it "returns error message if XML is invalid" do
      page = mock_test_page("xml/bad.xml")
      result = described_class.new(page).call

      expect(result.first).to eq("3:1: FATAL: Extra content at the end of the document")
    end
  end

  describe "#name" do
    it "returns xml" do
      expect(described_class.new(nil_page).name).to eq("xml")
    end
  end

  describe "#types" do
    it "returns [:xml]" do
      expect(described_class.new(nil_page).types).to eq([:xml])
    end
  end
end
