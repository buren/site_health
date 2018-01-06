module SiteHealth
  class W3CValidatorsConfiguration
    attr_accessor :css_uri, :html_uri

    def initialize
      @css_uri = W3CValidators::CSSValidator::CSS_VALIDATOR_URI
      @html_uri = W3CValidators::NuValidator::MARKUP_VALIDATOR_URI
    end

    def css_config
      { validator_uri: css_uri }
    end

    def html_config
      { validator_uri: html_uri }
    end
  end
end
