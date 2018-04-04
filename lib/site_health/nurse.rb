require "site_health/url_map"
require "site_health/event_emitter"

module SiteHealth
  class EventHandler < EventEmitter.define(:journal, :failed_url, :check)
  end

  # Holds page analysis data
  class Nurse
    attr_reader :config, :failures, :clerk

    def initialize(config: SiteHealth.config)
      @config = config
      @pages_journal = UrlMap.new { {} }
      @failures = []
      @clerk = EventHandler.new
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
      clerk.emit_failed_url(url)
      @failures << url
    end

    # @return [Hash] result data
    def check_page(page)
      @pages_journal[page.url].tap do |journal|
        started_at = Time.now
        journal[:started_at] = started_at
        journal[:checked] = true

        journal[:url] = page.url
        journal[:content_type] = page.content_type
        journal[:http_status] = page.code
        journal[:redirect] = page.redirect?
        journal[:title] = page.title
        journal[:links_to] = page.each_url.map do |url|
          (@pages_journal[url][:links_from] ||= []) << page.url
          url.to_s
        end

        journal[:checks] = lab_results(page)

        finished_at = Time.now
        journal[:finished_at] = finished_at
        journal[:runtime_in_seconds] = (finished_at - started_at).round(1)

        clerk.emit_journal(journal, page)
      end
    end

    # @return [Hash] results of all checkers for page
    def lab_results(page)
      {}.tap do |journal|
        config.checkers.each do |checker_klass|
          checker = checker_klass.new(page, config: config)
          next unless checker.should_check?

          checker_name = checker.name.to_sym
          result = checker.call

          clerk.emit_check(checker_name, result)
          journal[checker_name] = result
        end
      end
    end
  end
end
