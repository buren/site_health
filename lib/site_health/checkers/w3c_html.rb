require "w3c_validators"

require "site_health/w3c_journal_builder"

module SiteHealth
  # Checks for various HTML errors and warnings (backed by the excellent W3CValidations gem)
  class W3CHTML < Checker
    name "w3c_html"
    types "html"

    def check
      result = check_content
      # @return [Hash] with :errors and :warnings keys that return an error of possible violations
      add_data(
        errors: result.errors.map { |e| W3CJournalBuilder.build(e) },
        warnings: result.warnings.map { |e| W3CJournalBuilder.build(e) }
      )
    end

    # @return [W3CValidators::Results]
    # @raise [W3CValidators::ValidatorUnavailable] the service is offline or returns 400 Bad Request
    # @see https://github.com/w3c-validators/w3c_validators/issues/39 we really want to use #validate_text instead of #validate_uri but due to the linked issue thats not possible
    def check_content
      validator = W3CValidators::NuValidator.new(SiteHealth.config.w3c.html_config)
      validator.validate_text(page.body)
    end
  end
end
