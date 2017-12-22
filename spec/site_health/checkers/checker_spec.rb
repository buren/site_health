require "spec_helper"

RSpec.describe SiteHealth::Checker do
  describe "#call" do
    it "raises NotImplementedError" do
      expect do
        described_class.new(nil).call
      end.to raise_error(NotImplementedError)
    end
  end

  describe "#url" do
    it "returns the page URL" do
      url = "http://example.com/wat"
      page = Struct.new(:url).new(url)
      checker = described_class.new(page)

      expect(checker.url).to eq(url)
    end
  end

  describe "#name" do
    it "returns pretty class name for class with \"Checker\" suffix" do
      WatChecker = Class.new(described_class)
      expect(WatChecker.new(nil).name).to eq("wat")
    end

    it "returns pretty class name by default" do
      WatSomething = Class.new(described_class)
      expect(WatSomething.new(nil).name).to eq("watsomething")
    end
  end

  describe "#types" do
    it "returns all checkable types" do
      expect(described_class.new(nil).types).to eq(described_class::CHECKABLE_TYPES)
    end
  end

  describe "#should_check?" do
    let(:html_page) do
      Class.new do
        def html?
          true
        end

        def json?
          false
        end
      end.new
    end

    it "returns true if active on page content type" do
      checker = Class.new(described_class) do
        def types
          %i[html]
        end
      end

      expect(checker.new(html_page).should_check?).to eq(true)
    end

    it "returns false if *not* active on page content type" do
      checker = Class.new(described_class) do
        def types
          %i[json]
        end
      end

      expect(checker.new(html_page).should_check?).to eq(false)
    end
  end
end
