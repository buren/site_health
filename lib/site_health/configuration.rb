require "site_health/html_proofer_configuration"

module SiteHealth
  # Holds configuration data
  class Configuration
    def initialize
      @checkers = nil
      @html_proofer = nil
      @w3c = nil
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
    def checkers
      # NOTE:
      #   We can't initialize the default checkers in the constructor since
      #   those files, might not yet be required
      @checkers || default_checkers
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
        Checkers::HTMLProofer,
        Checkers::MissingTitle,
        Checkers::MissingDescription,
        Checkers::Redirect,
        Checkers::XML,
        Checkers::JSONSyntax
      ]
    end
  end
end
