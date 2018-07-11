# frozen_string_literal: true

require "site_health/url_map"
require "site_health/event_emitter"
require "site_health/timer"

module SiteHealth
  # Holds page analysis data
  class Nurse
    attr_reader :config, :failures, :checkers

    def initialize(config: SiteHealth.config)
      @config = config
      @checkers = config.checkers
      @pages_journal = UrlMap.new { {} }
      @failures = []
      @clerk = nil
    end

    # @return [Hash] check results
    def journal
      {
        checked_urls: @pages_journal.to_h,
        internal_server_error_urls: failures,
      }
    end

    # @return [Array] all URL that have failed
    def check_failed_url(url)
      clerk.emit_failed_url(url)
      @failures << url
    end

    # @return [Object] the event emitter
    # @yieldparam [Object] the event emiiter
    def clerk
      @clerk ||= begin
        events = %w[journal failed_url check].concat(checkers.map(&:name))
        EventEmitter.define(*events).new.tap { |e| yield(e) if block_given? }
      end
    end

    # @return [Hash] result data
    def check_page(page)
      @pages_journal[page.url].tap do |journal|
        timer = Timer.start
        journal[:started_at] = timer.started_at
        journal[:checked] = true

        journal[:url] = page.url
        journal[:content_type] = page.content_type
        journal[:http_status] = page.code
        journal[:redirect] = page.redirect?
        journal[:title] = page.title
        journal[:links_to] = page.each_link.map do |url|
          (@pages_journal[url][:links_from] ||= []) << page.url
          url.to_s
        end

        journal[:checks] = lab_results(page)

        timer.finish

        journal[:finished_at] = timer.finished_at
        journal[:runtime_in_seconds] = timer.diff.round(1)

        clerk.emit_journal(journal, page)
      end
    end

    # @return [Hash] results of all checkers for page
    def lab_results(page)
      journal = {}
      checkers.each do |checker_klass|
        checker = checker_klass.new(page, config: config)
        next unless checker.should_check?

        checker.call

        clerk.emit_check(checker)
        clerk.emit(checker.name, checker)

        journal[checker.name.to_sym] = checker.to_h
      end
      journal
    end
  end
end
