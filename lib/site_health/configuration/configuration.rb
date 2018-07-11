require "set"
require "site_health/null_logger"
require "site_health/configuration/html_proofer_configuration"
require "site_health/configuration/w3c_validators_configuration"

module SiteHealth
  # Holds configuration data
  class Configuration
    attr_reader :checkers, :google_page_speed_api_key, :logger, :locale

    def initialize
      @checkers = Set.new(default_checkers)
      @html_proofer = nil
      @w3c = nil
      @google_page_speed_api_key = nil
      @logger = NullLogger.new
      @locale = 'en'
    end

    # Set logger
    # @return [Object] the set logger
    # @param [Object] logger an object than response to quacks like a Logger
    # @example set a logger that prints to standard out (STDOUT)
    #    SiteHealth.logger = Logger.new(STDOUT)
    def logger=(logger)
      @logger = logger
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
      @checkers = Array(checkers).map! { |checker| register_checker(checker) }
    end

    # @param [Checker] checker additional checker to run
    # @return [Checker] the registered checker
    def register_checker(checker)
      checker_klass = checker

      if checker.respond_to?(:to_sym)
        checker_klass = SiteHealth.load_checker(checker)
      end

      @checkers << checker_klass
      checker_klass
    end

    # @return [Array<Checker>] array of default checkers to run
    def default_checkers
      %i[
        facebook_share_link
        missing_title
        missing_description
        redirect
        xml
        json_syntax
        page_not_found
      ].map! { |name| SiteHealth.load_checker(name)  }
    end
  end
end
