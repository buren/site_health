require "spec_helper"

RSpec.describe SiteHealth::Checker do
  describe "::name" do
    it "can set & get name in subclass class-macro" do
      page = Struct.new(:url).new("http://example.com/wat")
      checker_klass = Class.new(described_class) do
        name 'checker_test_klass'
      end
      checker = checker_klass.new(page)

      expect(checker.name).to eq('checker_test_klass')
    end

    it "returns default checkable types when no types is set" do
      page = Struct.new(:url).new("http://example.com/wat")
      checker_klass = Class.new(described_class)
      checker = checker_klass.new(page)
      allow(SecureRandom).to receive(:hex).and_return('fake_hex_string')

      expect(checker.name).to eq('fake_hex_string')
    end
  end

  describe "::types" do
    it "can set & get types in subclass class-macro" do
      page = Struct.new(:url).new("http://example.com/wat")
      checker_klass = Class.new(described_class) do
        types "xml"
      end
      checker = checker_klass.new(page)

      expect(checker.types).to eq(%i[xml])
    end

    it "can set (from array) & get types in subclass class-macro" do
      page = Struct.new(:url).new("http://example.com/wat")
      checker_klass = Class.new(described_class) do
        types %w[xml]
      end
      checker = checker_klass.new(page)

      expect(checker.types).to eq(%i[xml])
    end

    it "returns default checkable types when no types is set" do
      page = Struct.new(:url).new("http://example.com/wat")
      checker = described_class.new(page)

      expect(checker.types).to eq(described_class::CHECKABLE_TYPES)
    end
  end

  describe "#call" do
    it "returns self" do
      page = Struct.new(:url, :plain_text?).new("http://example.com", plain_text?: true)
      checker = described_class.new(page)
      allow(checker).to receive(:check).and_return(nil)

      expect(checker.call).to eq(checker)
    end

    it "yields self" do
      page = Struct.new(:url, :plain_text?).new("http://example.com", plain_text?: true)
      checker = described_class.new(page)
      allow(checker).to receive(:check).and_return(nil)

      checker.call do |ch|
        expect(checker).to eq(ch)
      end
    end
  end

  describe "#to_h" do
    it "returns a hash representation of the object" do
      page = Struct.new(:url).new("http://example.com/wat")
      checker = described_class.new(page)

      expect(checker.to_h).to eq(name: :checker, data: {}, issues: [])
    end
  end

  describe "#check" do
    it "raises NotImplementedError" do
      expect do
        # we must use #send here since the method is protected
        described_class.new(nil).send(:check)
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

  describe "#add_issue" do
    it "adds issue to the issues list" do
      page = Struct.new(:url).new("http://example.com/wat")
      checker = described_class.new(page)
      checker.add_issue(code: :watman, title: "is invalid")

      expect(checker.issues.first.code).to eq(:watman)
    end
  end

  describe "#add_data" do
    it "merges the new data with the current data" do
      page = Struct.new(:url).new("http://example.com/wat")
      checker = described_class.new(page)
      checker.add_data(any: :thing)
      checker.add_data(any: :thang)

      expect(checker.data.to_h).to eq(any: :thang)
    end
  end
end
