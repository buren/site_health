require "site_health/html_proofer_configuration"
require "site_health/w3c_validators_configuration"

module SiteHealth
  # Holds configuration data
  class Configuration
    attr_reader :checkers, :google_page_speed_api_key

    def initialize
      @checkers = default_checkers
      @html_proofer = nil
      @w3c = nil
      @google_page_speed_api_key = nil
    end

    # @return [HTMLProoferConfiguration] the current configuration
    # @yieldparam [HTMLProoferConfiguration] the current configuration
    def html_proofer
      @html_proofer ||= HTMLProoferConfiguration.new
      yield(@html_proofer) if block_given?
      @html_proofer
    end

    # @return [W3CValidatorsConfiguration] the current configuration
    # @yieldparam [W3CValidatorsConfiguration] the current configuration
    def w3c
      @w3c ||= W3CValidatorsConfiguration.new
      yield(@w3c) if block_given?
      @w3c
    end

    # @return [Array<Checker>] array of checkers to run
    # @param [Array<Checker>] checkers array of checkers to run
    def checkers=(checkers)
      @checkers = Array(checkers)
    end

    # @param [Checker] checker additional checker to run
    # @return [Array<Checker>] array of checkers to run
    def register_checker(checker)
      @checkers << checker
    end

    # @return [Array<Checker>] array of default checkers to run
    def default_checkers
      [
        HTMLProofer,
        MissingTitle,
        MissingDescription,
        Redirect,
        XML,
        JSONSyntax
      ]
    end
  end
end
