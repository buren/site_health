# frozen_string_literal: true

require 'set'

module SiteHealth
  # Represents a found issue inspired by the JSONAPI error spec
  class Issue
    PRIORITIES = Set.new(
      %i[
        critial
        high
        medium
        low
        fyi
        unknown
      ].freeze
    )

    SEVERITIES = Set.new(
      %i[
        critial
        major
        medium
        low
        fyi
        unknown
      ].freeze
    )

    attr_accessor :name, :code, :url, :meta
    attr_reader :title, :detail, :links, :severity, :priority

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
      url: nil,
      links: [],
      meta: {}
    )
      self.name = name
      self.code = code
      self.url = url
      self.meta = meta
      self.title = title
      self.detail = detail
      self.links = links
      self.severity = severity
      self.priority = priority
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
        url: url,
        links: links,
        meta: meta,
      }
    end

    # Set issue title.
    # @param [String] title
    def title=(title)
      @title = title.to_s
    end

    # Set issue detail.
    # @param [String] detail
    def detail=(detail)
      @detail = detail.to_s
    end

    # Set issue links.
    # @param [Array<Hash>] links
    # @raise [ArgumentError] if href key is not present
    def links=(links)
      links.each do |link|
        next if link.key?(:href)
        raise ArgumentError, 'href key must be present for every link'
      end

      @links = links
    end

    # Set issue priority.
    # @param [String, Symbol] priority
    # @raise [ArgumentError] if priority is unknown
    def priority=(priority)
      priority = priority.to_sym

      unless PRIORITIES.include?(priority)
        priorities = PRIORITIES.to_a.join(', ')
        raise ArgumentError, "unknown value: '#{priority}', chose one of #{priorities}."
      end

      @priority = priority
    end

    # Set issue severity.
    # @param [String, Symbol] severity
    # @raise [ArgumentError] if severity is unknown
    def severity=(severity)
      severity = severity.to_sym

      unless SEVERITIES.include?(severity)
        severities = SEVERITIES.to_a.join(', ')
        raise ArgumentError, "unknown value: '#{severity}', chose one of #{severities}."
      end

      @severity = severity
    end
  end
end
