require "spec_helper"

require "site_health/checkers/redirect"

RSpec.describe SiteHealth::Redirect do
  describe "#call" do
    it "returns true if page is a redirect page" do
      page = OpenStruct.new(redirect?: true)
      result = described_class.new(page).call

      expect(result).to eq(true)
    end

    it "returns false if page is *not* a redirect page" do
      page = OpenStruct.new(redirect?: false)
      result = described_class.new(page).call

      expect(result).to eq(false)
    end
  end

  describe "#name" do
    it "returns redirect" do
      expect(described_class.new(nil_page).name).to eq("redirect")
    end
  end
end
