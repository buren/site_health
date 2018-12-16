# frozen_string_literal: true

require 'site_health/url_map'
require 'site_health/event_emitter'
require 'site_health/timer'

module SiteHealth
  # Holds page analysis data
  class Nurse
    attr_reader :config, :failures, :checkers

    # @return [Array<Issue>] found issues
    attr_reader :issues

    def initialize(config: SiteHealth.config)
      @config = config
      @checkers = config.checkers
      @pages_journal = UrlMap.new { {} }
      @failures = []
      @issues = []
      @clerk = nil
      @punched_out = false
    end

    # @return [Nurse] returns self
    def punch_out!
      post_shift_analysis unless @punched_out

      @punched_out = true
      self
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
        events = %w[journal failed_url check page issue].concat(checkers.map(&:name))
        EventEmitter.define(*events).new.tap { |e| yield(e) if block_given? }
      end
    end

    # @return [Hash] result data
    def check_page(page)
      @pages_journal[page.url].tap do |journal|
        timer = Timer.start
        clerk.emit_page(page)

        journal[:started_at] = timer.started_at
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

        timer.finish

        journal[:finished_at] = timer.finished_at
        journal[:runtime_in_seconds] = timer.diff.round(3)

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

        issues = checker.issues
        @issues.concat(issues.to_a)

        clerk.emit_check(checker)
        clerk.emit(checker.name, checker)
        clerk.emit_each_issue(issues)

        journal[checker.name.to_sym] = checker.to_h
      end
      journal
    end

    # Provides transparent access to the methods in {#clerk}.
    # @param [Symbol] name
    #   The name of the missing method.
    # @param [Array] arguments
    #   Additional arguments for the missing method.
    # @raise [NoMethodError]
    #   The missing method did not map to a method in {#clerk}.
    # @see #clerk
    def method_missing(method, *args, &block)
      if clerk.respond_to?(method)
        return clerk.public_send(method, *args, &block)
      end

      super
    end

    # @param [Symbol] name
    #   The name of the missing method.
    # @param [Boolean] include_private optional (default: false)
    #   Whether to include private methods
    # @return [Boolean]
    #   true if it can respond to method name, false otherwise
    def respond_to_missing?(method, include_private = false)
      clerk.respond_to?(method, include_private) || super
    end

    private

    def post_shift_analysis
      issues = links_to_page_not_found_issues
      clerk.emit_each_issue(issues)
      @issues.concat(issues)
    end

    def links_to_page_not_found_issues
      issues = []
      not_found = @issues.
                  select { |issue| issue.code == :not_found }.
                  map { |issue| issue.url.to_s }

      not_found.each do |url|
        (@pages_journal[url][:links_from] || []).each do |link_from_url|
          issues << build_links_to_not_found_issue(link_from_url, url)
        end
      end

      issues
    end

    def build_links_to_not_found_issue(url, not_found_url)
      Issue.new(
        name: 'links_to_page_not_found',
        code: :links_to_not_found,
        title: 'Links to page not found',
        detail: "Links to #{not_found_url} that is 404 page not found",
        severity: :major,
        priority: :high,
        url: url
      )
    end
  end
end
