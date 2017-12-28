require "spec_helper"

require "site_health/checkers/missing_title"

RSpec.describe SiteHealth::Checkers::MissingTitle do
  describe "#call" do
    it "returns false if title is present" do
      page = mock_test_page("html/index.html")
      result = described_class.new(page).call

      expect(result).to eq(false)
    end

    it "returns true if title is missing" do
      page = mock_test_page("html/missing_title.html")
      result = described_class.new(page).call

      expect(result).to eq(true)
    end

    it "returns true if title is present, but empty" do
      page = mock_test_page("html/empty_title.html")
      result = described_class.new(page).call

      expect(result).to eq(true)
    end
  end

  describe "#name" do
    it "returns missing_title" do
      expect(described_class.new(nil_page).name).to eq("missing_title")
    end
  end

  describe "#types" do
    it "returns [:html]" do
      expect(described_class.new(nil_page).types).to eq([:html])
    end
  end
end
