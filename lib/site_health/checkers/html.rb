require "w3c_validators"

module SiteHealth
  module Checkers
    class HTML < Checker
      def call
        # result = check_content
        result = Struct.new(:errors, :warnings).new([], [])
        {
          title: page.title,
          missing_title: missing_title?,
          redirect: redirect?,
          errors: result.errors.map { |e| W3CJournalBuilder.build(e) },
          warnings: result.warnings.map { |e| W3CJournalBuilder.build(e) }
        }
      end

      def name
        "w3c_validator"
      end

      def types
        %i[html]
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
