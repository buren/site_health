require "spec_helper"
require "ostruct"

RSpec.describe SiteHealth::Checkers::HTMLPage do
  describe "#missing_title?" do
    def build_mock_html_checker(data)
      OpenStruct.new(
        page: OpenStruct.new(title: data[:title]), redirect?: data[:redirect?]
      )
    end

    it "returns false even if title is empty on redirect page" do
      page = build_mock_html_checker(redirect?: true, title: nil)
      checker = described_class.new(page)

      expect(checker.missing_title?).to eq(false)
    end

    it "returns true if title is nil" do
      page = build_mock_html_checker(title: nil)
      checker = described_class.new(page)

      expect(checker.missing_title?).to eq(true)
    end

    it "returns true if title is blank" do
      page = build_mock_html_checker(title: " ")
      checker = described_class.new(page)

      expect(checker.missing_title?).to eq(true)
    end

    it "returns false if title is presnet" do
      page = build_mock_html_checker(title: "Page title")
      checker = described_class.new(page)

      expect(checker.missing_title?).to eq(true)
    end
  end

  describe "::check" do
    def build_mock_html_checker(data)
      OpenStruct.new(
        url: data[:url],
        redirect?: data[:redirect?],
        page: OpenStruct.new(title: data[:title])
      )
    end

    it "returns HTMLJournal" do
      url = "https://example.com"
      page = build_mock_html_checker(url: url)
      checker = described_class.new(page)

      check_content_result = OpenStruct.new(errors: [], warnings: [])
      allow(checker).to receive(:check_content).and_return(check_content_result)

      result = checker.check
      expect(result.url). to eq(url)
      expect(result.class).to eq(SiteHealth::HTMLJournal)
    end
  end
end
