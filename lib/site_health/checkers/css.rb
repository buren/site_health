require "w3c_validators"

module SiteHealth
  module Checkers
    class CSS < Checker
      def call
        result = check_content

        {
          errors: result.errors.map { |e| W3CJournalBuilder.build(e) },
          warnings: result.warnings.map { |e| W3CJournalBuilder.build(e) }
        }
      end

      def name
        "css"
      end

      def types
        %i[css]
      end

      # @return [W3CValidators::Results]
      # @raise [W3CValidators::ValidatorUnavailable] the service is offline or returns 400 Bad Request
      # @see https://github.com/w3c-validators/w3c_validators/issues/39 we really want to use #validate_text instead of #validate_uri but due to the linked issue thats not possible
      def check_content
        validator = W3CValidators::CSSValidator.new
        validator.validate_uri(url)
      end
    end
  end
end
