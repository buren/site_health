module SiteHealth
  class Checker
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

    # @see #call
    def self.call(page)
      new(page).call
    end

    attr_reader :page

    # @param [Spidr::Page] the crawled page
    def initialize(page)
      @page = page
    end

    def call
      fail(NotImplementedError, "please implement!")
    end

    def url
      page.url
    end

    def name
      checker_name = self.class.name.downcase
      return checker_name[0..-8] if checker_name.end_with?("checker")

      checker_name
    end

    def types
      CHECKABLE_TYPES
    end

    def should_check?
      types.any? { |type| page.public_send("#{type}?") }
    end
  end
end
