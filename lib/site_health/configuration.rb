require "site_health/html_proofer_configuration"

module SiteHealth
  class Configuration
    attr_reader :checkers, :html_proofer

    def initialize
      @checkers = nil
      @html_proofer = nil
    end

    def html_proofer
      @html_proofer = HTMLProoferConfiguration.new
      yield(@html_proofer) if block_given?
      @html_proofer
    end

    # NOTE:
    #   We can't initialize the default checkers in the constructor since
    #   those files are yet to be required
    def checkers
      @checkers || default_checkers
    end

    def checkers=(checkers)
      @checkers = Array(checkers)
    end

    def register_checker(checker)
      @checkers << checker
    end

    def default_checkers
      [
        Checkers::HTMLProofer,
        Checkers::MissingTitle,
        Checkers::Redirect,
        Checkers::XML,
        Checkers::JSONSyntax
      ]
    end
  end
end