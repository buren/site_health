module SiteHealth
  module Checkers
    class XMLPage
      def self.check(page)
        new(page).check
      end

      attr_reader :page, :url

      # @param [Spidr::Page] the crawled page
      def initialize(page)
        @page = page
        @url = page.url
      end

      def check
        XMLJournal.new(url: url, page: page, errors: page.doc.errors)
      end
    end
  end
end
