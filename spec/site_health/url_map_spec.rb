# frozen_string_literal: true

require "spec_helper"
require "site_health/url_map"

RSpec.describe SiteHealth::UrlMap do
  describe "#[] & #[]=" do
    it "sets and gets value ands converts the key to a string" do
      map = described_class.new.tap { |m| m[:wat] = :man }

      expect(map[:wat]).to eq(:man)
      expect(map["wat"]).to eq(:man)
    end
  end

  it "quacks like an Enumerable" do
    map = described_class.new.tap { |m| m[:wat] = :man }

    expect(map.map.to_a).to eq([["wat", :man]])
    expect(map.to_a).to eq([["wat", :man]])
  end

  it "returns the default value if configured" do
    map = described_class.new { [] }
    expect(map[:wat] << 1).to eq([1])
  end

  describe "#to_h" do
    it "returns the UrlMap as a hash" do
      map = described_class.new
      map[:wat] = 1
      expect(map.to_h).to eq("wat" => 1)
    end
  end
end
