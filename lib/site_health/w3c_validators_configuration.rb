module SiteHealth
  # Holds W3CValidators configuration data
  class W3CValidatorsConfiguration
    attr_accessor :css_uri, :html_uri

    def initialize
      @css_uri = W3CValidators::CSSValidator::CSS_VALIDATOR_URI
      @html_uri = W3CValidators::NuValidator::MARKUP_VALIDATOR_URI
    end

    # @return [Hash] configuration for W3CValidators::CSSValidator
    def css_config
      { validator_uri: css_uri }
    end

    # @return [Hash] configuration for W3CValidators::NuValidator
    def html_config
      { validator_uri: html_uri }
    end
  end
end
