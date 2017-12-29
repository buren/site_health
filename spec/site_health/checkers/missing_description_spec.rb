require "spec_helper"

require "site_health/checkers/missing_description"

RSpec.describe SiteHealth::Checkers::MissingDescription do
  describe "#call" do
    it "returns false if description is present" do
      page = mock_test_page("html/index.html")
      result = described_class.new(page).call

      expect(result).to eq(false)
    end

    it "returns true if description is missing" do
      page = mock_test_page("html/missing_description.html")
      result = described_class.new(page).call

      expect(result).to eq(true)
    end

    it "returns true if description is present, but empty" do
      page = mock_test_page("html/empty_description.html")
      result = described_class.new(page).call

      expect(result).to eq(true)
    end
  end

  describe "#name" do
    it "returns missing_description" do
      expect(described_class.new(nil_page).name).to eq("missing_description")
    end
  end

  describe "#types" do
    it "returns [:html]" do
      expect(described_class.new(nil_page).types).to eq([:html])
    end
  end
end
