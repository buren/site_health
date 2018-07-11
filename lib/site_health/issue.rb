# frozen_string_literal: true

module SiteHealth
  class Issue
    class MissingLinkHrefKey < ArgumentError; end

    PRIORITIES = %i[
      critial
      high
      medium
      low
      fyi
      unknown
    ].freeze

    SEVERITIES = %i[
      critial
      major
      medium
      low
      fyi
      unknown
    ].freeze

    attr_reader :name, :code, :title, :detail, :links, :meta, :severity, :priority

    # Initialize an Issue
    # @param [String, Symbol] code an application-specific error code.
    # @param [String] title a short, human-readable summary of the problem.
    # @param [String] detail
    #  a human-readable explanation specific to this occurrence of the problem.
    # @param [Array<Link>]
    def initialize(
      name:,
      title:,
      code: nil,
      detail: '',
      severity: :unknown,
      priority: :unknown,
      links: [],
      meta: {}
    )
      @name = name
      @code = code&.to_sym
      @title = title.to_s
      @detail = detail.to_s
      @severity = severity.to_sym.tap { validate_severity!(severity) }
      @priority = priority.to_sym.tap { validate_priority!(priority) }
      @links = links.tap { validate_links!(links) }
      @meta = meta
    end

    # @return [Hash] hash representation of the object
    def to_h
      {
        name: name,
        code: code,
        title: title,
        detail: detail,
        severity: severity,
        priority: priority,
        links: links,
        meta: meta,
      }
    end

    private

    def validate_severity!(severity)
      return if SEVERITIES.include?(severity)
      severities = SEVERITIES.join(', ')
      raise ArgumentError, "unknown value: '#{severity}', chose one of #{severities}."
    end

    def validate_priority!(priority)
      return if PRIORITIES.include?(priority)
      priorities = PRIORITIES.join(', ')
      raise ArgumentError, "unknown value: '#{severity}', chose one of #{priorities}."
    end

    def validate_links!(links)
      links.each do |link|
        next if link.key?(:href)
        raise ArgumentError, 'href key must be present for every link'
      end
    end
  end
end
