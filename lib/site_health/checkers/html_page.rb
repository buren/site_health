module SiteHealth
  module Checkers
    class HTMLPage
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
        result = check_content

        HTMLJournal.new(
          url: url,
          page: page,
          missing_title: missing_title?,
          errors: result.errors.map { |e| W3CJournalBuilder.build(e) },
          warnings: result.warnings.map { |e| W3CJournalBuilder.build(e) }
        )
      end

      def missing_title?
        page.title.to_s.strip.empty?
      end

      # @return [W3CValidators::Results]
      # @raise [W3CValidators::ValidatorUnavailable] the service is offline or returns 400 Bad Request
      # @see https://github.com/w3c-validators/w3c_validators/issues/39 we really want to use #validate_text instead of #validate_uri but due to the linked issue thats not possible
      def check_content
        validator = W3CValidators::NuValidator.new
        validator.validate_uri(url)
      end
    end
  end
end
