require "spec_helper"

require "site_health/configuration"

RSpec.describe SiteHealth::Configuration do
  describe "#w3c" do
    it "returns an instance of W3CValidatorsConfiguration" do
      expect(described_class.new.w3c).to be_a(SiteHealth::W3CValidatorsConfiguration)
    end
  end

  describe "#html_proofer" do
    it "returns an instance of HTMLProoferConfiguration" do
      expect(described_class.new.html_proofer).to be_a(SiteHealth::HTMLProoferConfiguration)
    end
  end

  describe "#checkers=" do
    it "can reassign checkers" do
      my_checker_klass = Class.new

      config = described_class.new
      config.checkers = my_checker_klass

      expect(config.checkers).to eq([my_checker_klass])
    end
  end

  describe "#register_checker" do
    it "can add checker" do
      my_checker_klass = Class.new

      config = described_class.new
      config.register_checker(my_checker_klass)

      expect(config.checkers).to include(my_checker_klass)
    end
  end
end
