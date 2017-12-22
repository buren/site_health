require "site_health/url_map"

module SiteHealth
  class Nurse
    def initialize
      @journal = UrlMap.new { {} }
      @links_to = UrlMap.new { [] }
      @links_from = UrlMap.new { [] }
      @failures = []
    end

    # @return [Hash]
    def journal
      @journal.tap do |journal|
        @links_from.each do |destination, origins|
          journal[destination][:links_from] = origins
        end

        @links_to.each do |origin, destinations|
          journal[origin][:links_to] = destinations
        end

        journal[:server_error_urls] = @failures
      end
    end

    # @return [Array] all URL that have failed
    def add_failed_url(url)
      @failures << url
    end

    # @return [Hash] with from/to links
    def add_link(origin, destination)
      {
        from: @links_from[destination] << origin,
        to: @links_to[origin] << destination
      }
    end

    # @return [Hash]
    def add_page(page)
      @journal[page.url].tap do |journal|
        journal[:content_type] = page.content_type
        journal[:http_status] = page.code
        journal[:redirect] = page.redirect?
        journal.merge!(checkers(page))
      end
    end

    def checkers(page)
      {}.tap do |journal|
        SiteHealth.config.checkers.each do |klass|
          checker = klass.new(page)
          next unless checker.should_check?

          journal[checker.name.to_sym] = checker.call
        end
      end
    end
  end
end
