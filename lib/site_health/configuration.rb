module SiteHealth
  class Configuration
    attr_reader :checkers, :html_proofer

    def initialize
      @checkers = nil
      # TODO: Provide transparent access to HTMLProofer options
      @html_proofer = {
        log_level: :fatal # one of: :debug, :info, :warn, :error, or :fatal
      }
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
        Checkers::HTML,
        Checkers::MissingTitle,
        Checkers::Redirect,
        Checkers::XML,
        Checkers::CSS,
        Checkers::JSON
      ]
    end
  end
end