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

    attr_reader :page, :config

    # @param [Spidr::Page] page the crawled page
    # @param config [SiteHealth::Configuration]
    def initialize(page, config: SiteHealth.config)
      @page = page
      @config = config
    end

    # Abstract method that subclasses must implement
    # @raise [NotImplementedError] subclasses must implement
    def call
      raise(NotImplementedError, "please implement!")
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
  end
end
