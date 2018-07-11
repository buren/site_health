# frozen_string_literal: true

require "spec_helper"
require "site_health/configuration/html_proofer_configuration"

RSpec.describe SiteHealth::HTMLProoferConfiguration do
  describe "#log_level" do
    it "can assign a new, valid, log level" do
      config = described_class.new
      config.log_level = :debug
      expect(config.log_level).to eq(:debug)
    end

    it "raises ArgumentError for invalid log level" do
      config = described_class.new
      expect do
        config.log_level = :watman
      end.to raise_error(ArgumentError)
    end
  end

  describe "#error_sort" do
    it "can assign a new, valid, error sort" do
      config = described_class.new
      config.error_sort = :status
      expect(config.error_sort).to eq(:status)
    end

    it "raises ArgumentError for invalid error sort" do
      config = described_class.new
      expect do
        config.error_sort = :watman
      end.to raise_error(ArgumentError)
    end
  end
end
