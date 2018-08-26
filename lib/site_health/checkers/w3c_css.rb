# frozen_string_literal: true

require 'site_health/w3c_journal_builder'
SiteHealth.require_optional_dependency('w3c_validators')

module SiteHealth
  # Checks for various CSS errors and warnings (backed by the excellent W3CValidations gem)
  class W3CCSS < Checker
    name 'w3c_css'
    types 'css'

    def check
      result = check_content
      # TODO: Add issues
      add_data(
        errors: result.errors.map { |e| W3CJournalBuilder.build(e) },
        warnings: result.warnings.map { |e| W3CJournalBuilder.build(e) }
      )
    end

    # @return [W3CValidators::Results]
    # @raise [W3CValidators::ValidatorUnavailable]
    #   service is offline or returns 400 Bad Request
    #   (which usually means being hit by rate limits)
    def check_content
      # NOTE: We really want to use #validate_text instead of #validate_uri but due
      # to the linked (below) issue thats not possible
      # https://github.com/w3c-validators/w3c_validators/issues/39
      validator = W3CValidators::CSSValidator.new(SiteHealth.config.w3c.css_config)
      validator.validate_text(page.body)
    end
  end

  SiteHealth.register_checker(W3CCSS)
end
