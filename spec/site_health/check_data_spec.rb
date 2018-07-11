require "spec_helper"

require "site_health/check_data"

RSpec.describe SiteHealth::CheckData do
  describe "[] and #add" do
    it "can retrieve key" do
      data = described_class.new
      data.add(wat: :man)
      
      expect(data[:wat]).to eq(:man)
    end
  end

  describe "#empty?" do
    it "returns true if there is no data" do
      data = described_class.new

      expect(data.empty?).to eq(true)
    end

    it "returns false if there is data" do
      data = described_class.new
      data.add(wat: :man)

      expect(data.empty?).to eq(false)
    end
  end

  describe "#each" do
    it "iterates over each item in data" do
      data = described_class.new
      data.add(wat: :man)
      data.each do |key, value|
        expect(key).to eq(:wat)
        expect(value).to eq(:man)
      end
    end
  end

  describe "#to_h" do
    it "returns object as hash" do
      data = described_class.new
      data.add(wat: :man)

      expect(data.to_h).to eq(wat: :man)
    end
  end
end