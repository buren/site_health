require "site_health/url_map"

module SiteHealth
  # Holds page analysis data
  class Nurse
    attr_reader :config

    def initialize(config = SiteHealth.config)
      @config = config
      @journal = UrlMap.new { {} }
      @links_to = UrlMap.new { [] }
      @links_from = UrlMap.new { [] }
      @failures = []
    end

    # @return [Hash] check results
    def journal
      @journal.tap do |journal|
        @links_from.each do |destination, origins|
          journal[destination][:links_from] = origins
        end

        @links_to.each do |origin, destinations|
          journal[origin][:links_to] = destinations
        end

        journal[:internal_server_error_urls] = @failures
      end
    end

    # @return [Array] all URL that have failed
    def check_failed_url(url)
      @failures << url
    end

    # @return [Hash] with from/to links
    def check_link(origin, destination)
      {
        from: @links_from[destination] << origin,
        to: @links_to[origin] << destination
      }
    end

    # @return [Hash]
    def check_page(page)
      @journal[page.url].tap do |journal|
        journal[:content_type] = page.content_type
        journal[:http_status] = page.code
        journal[:redirect] = page.redirect?
        journal[:title] = page.title
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
