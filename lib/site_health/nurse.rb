require "site_health/url_map"

module SiteHealth
  # Holds page analysis data
  class Nurse
    attr_reader :config, :failures

    def initialize(config: SiteHealth.config)
      @config = config
      @pages_journal = UrlMap.new { {} }
      @failures = []
    end

    # @return [Hash] check results
    def journal
      {
        checked_urls: @pages_journal.to_h,
        internal_server_error_urls: failures
      }
    end

    # @return [Array] all URL that have failed
    def check_failed_url(url)
      @failures << url
    end

    # @return [Hash]
    def check_page(page)
      @pages_journal[page.url].tap do |journal|
        journal[:content_type] = page.content_type
        journal[:http_status] = page.code
        journal[:redirect] = page.redirect?
        journal[:title] = page.title
        journal[:links_to] = page.each_url.map do |url|
          (@pages_journal[url][:links_from] ||= []) << page.url
          url.to_s
        end

        journal.merge!(lab_results(page))
      end
    end

    # @return [Hash] results of all checkers for page
    def lab_results(page)
      {}.tap do |journal|
        config.checkers.each do |klass|
          checker = klass.new(page, config: config)
          next unless checker.should_check?

          journal[checker.name.to_sym] = checker.call
        end
      end
    end
  end
end
