require "spec_helper"

require "site_health/nurse"

RSpec.describe SiteHealth::Nurse do
  describe "#journal" do
    it "returns empty UrlMap when given no data" do
      expect(described_class.new.journal).to be_a(SiteHealth::UrlMap)
    end
  end

  describe "#check_link" do
    it "returns current link data as hash" do
      nurse = described_class.new
      origin = "https://jacobburenstam.com"
      destination = "https://jacobburenstam.com/resume"
      
      result = nurse.check_link(origin, destination)

      expected = {
        from: ["https://jacobburenstam.com"],
        to: ["https://jacobburenstam.com/resume"]
      }
      expect(result).to eq(expected)
    end

    it "links_to" do
      nurse = described_class.new
      origin = "https://jacobburenstam.com"
      destination = "https://jacobburenstam.com/resume"
      
      nurse.check_link(origin, destination)

      links_to_result = {
        "https://jacobburenstam.com" => ["https://jacobburenstam.com/resume"]
      }
      expect(nurse.links_to.to_h).to eq(links_to_result)
    end

    it "links_from" do
      nurse = described_class.new
      origin = "https://jacobburenstam.com"
      destination = "https://jacobburenstam.com/resume"
      
      nurse.check_link(origin, destination)

      links_from_result = {
        "https://jacobburenstam.com/resume" => ["https://jacobburenstam.com"]
      }
      expect(nurse.links_from.to_h).to eq(links_from_result)
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