require "spec_helper"
require "site_health/checkers/google_page_speed"

RSpec.describe SiteHealth::GooglePageSpeed do
  describe "#perform_request" do
    let(:example_result) do
      checker = described_class.new(mock_page(url: "https://example.com"))

      result = nil
      VCR.use_cassette("#{checker.name}_perform_request") do
        result = checker.send(:perform_request)
      end

      result
    end

    it "returns 'kind' value" do
      result = example_result
      expect(result[:kind]).to eq("pagespeedonline#result")
    end

    it "returns localized_rule_name for avoid redirects rule" do
      result = example_result.dig(
        :formatted_results,
        :rule_results,
        :AvoidLandingPageRedirects,
        :localized_rule_name
      )
      expect(result).to eq("Avoid landing page redirects")
    end

    it "returns captcha result" do
      expect(example_result[:captcha_result]).to eq("CAPTCHA_NOT_NEEDED")
    end

    it "returns version" do
      expect(example_result[:version]).to eq(major: 1, minor: 15)
    end
  end
end
