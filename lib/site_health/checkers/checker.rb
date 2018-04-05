require "site_health/issue"

module SiteHealth
  # Parent class for all checkers (all checkers must inheirit from this class)
  class Checker
    # All possible page types that can be checked
    CHECKABLE_TYPES = %i[
      plain_text
      directory
      xsl
      rss
      atom
      ms_word
      pdf
      zip
      javascript
      json
      css
      xml
      html
    ].freeze

    attr_reader :page, :config, :logger, :issues, :data

    # @param [Spidr::Page] page the crawled page
    # @param config [SiteHealth::Configuration]
    def initialize(page, config: SiteHealth.config)
      @page = page
      @config = config
      @logger = config.logger
      @issues = []
      @data = {}
    end

    # Run the checker
    # @yieldparam [Checker] yields self
    # @return [CheckerResult] returns self
    def call
      check
      yield(self) if block_given?
      self
    end

    # @return [String] the page URL
    def url
      page.url
    end

    # @return [String] the name of the checker
    def name
      checker_name = self.class.name.downcase
      return checker_name[0..-8] if checker_name.end_with?("checker")

      checker_name
    end

    # @return [Array<Symbol>] list of page types the checker will run on
    def types
      CHECKABLE_TYPES
    end

    # @return [Boolean] determines whether the checker should run
    def should_check?
      types.any? { |type| page.public_send("#{type}?") }
    end

    # Adds an issue
    # @return [Array<Issue>] the current list of issues
    # @see Issue#initialize
    def add_issue(**args)
      issues << Issue.new(**args.merge(checker_name: name))
    end

    # @return [Hash] hash representation of the object
    def to_h
      {
        data: data.to_h,
        issues: issues.map(&:to_h)
      }
    end

    protected

    # Abstract method that subclasses must implement
    # @raise [NotImplementedError] subclasses must implement
    def check
      raise(NotImplementedError, "please implement!")
    end
  end
end
