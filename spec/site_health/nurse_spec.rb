require "spec_helper"

require "site_health/nurse"

RSpec.describe SiteHealth::Nurse do
  describe "#journal" do
    it "returns empty UrlMap when given no data" do
      expect(described_class.new.journal).to be_a(SiteHealth::UrlMap)
    end
  end

  describe "#check_failed_url" do
    it "adds url to failures" do
      url = "https://jacobburenstam.com"
      nurse = described_class.new
      nurse.check_failed_url(url)

      expect(nurse.failures).to eq([url])
    end
  end

  describe "#check_page"
  describe "#lab_results"
end
