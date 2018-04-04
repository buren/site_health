require "spec_helper"
require "site_health/checkers/facebook_share_link"

RSpec.describe SiteHealth::FacebookShareLink do
  describe "call" do
    [
      # urls, expected
      ["https://stackoverflow.com", :ignored],
      ["https://developers.facebook.com/docs/sharing", :ignored],
      ["https://www.facebook.com/shares", :ignored],
      ["https://www.example.com/sharer/sharer.php", :ignored]
    ].each do |data|
      url, status = data

      it "ignores urls that does not look like Facebook share links" do
        page = Struct.new(:url).new(URI.parse(url))
        checker = SiteHealth::FacebookShareLink.new(page)
        expect(checker.call[:code]).to eq(status)
      end
    end

    it "ignores non-absolute urls" do
      url = "facebook.com/sharer/sharer.php"
      page = Struct.new(:url).new(URI.parse(url))
      checker = SiteHealth::FacebookShareLink.new(page)
      expect(checker.call[:code]).to eq(:invalid)
    end

    xit "adds protocol to url that starts with //" do
      url = "//facebook.com/sharer/sharer.php"
      page = Struct.new(:url).new(URI.parse(url))
      checker = SiteHealth::FacebookShareLink.new(page)
      expect(checker.call[:code]).to eq(:valid)
    end

    context "when using *deprecated* /sharer/ path" do
      valid_base_url = "https://www.facebook.com/sharer/sharer.php"
      share_url = "http://example.com"
      bad_share_url = "example.com"

      [
        # url, status
        ["#{valid_base_url}?u=#{share_url}", :valid],
        ["https://facebook.com/sharer/sharer.php?u=#{share_url}", :valid],
        ["http://facebook.com/sharer/sharer.php?u=#{share_url}", :valid],
        ["https://www.facebook.com/sharer.php?u=#{share_url}", :invalid],
        ["#{valid_base_url}?u=#{bad_share_url}", :invalid]
      ].each do |data|
        url, status = data

        it "returns #{status} status for #{url}" do
          page = Struct.new(:url).new(URI.parse(url))
          checker = SiteHealth::FacebookShareLink.new(page)
          expect(checker.call[:code]).to eq(status)
        end

        it "adds deprecated notice for #{url}" do
          page = Struct.new(:url).new(URI.parse(url))
          checker = SiteHealth::FacebookShareLink.new(page)
          message = checker.call[:message]
          expect(message.include?('[DEPCREATED]')).to eq(true)
        end
      end
    end
  end
end
