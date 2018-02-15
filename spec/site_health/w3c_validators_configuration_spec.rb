require "spec_helper"
require "site_health/w3c_validators_configuration"

RSpec.describe SiteHealth::W3CValidatorsConfiguration do
  describe "#css_config" do
    it "has a validator_uri key" do
      expect(described_class.new.css_config[:validator_uri]).not_to be_nil
    end
  end

  describe "#html_config" do
    it "has a validator_uri key" do
      expect(described_class.new.html_config[:validator_uri]).not_to be_nil
    end
  end
end
