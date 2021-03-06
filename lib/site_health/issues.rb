# frozen_string_literal: true

module SiteHealth
  class Issues
    include Enumerable

    attr_reader :id

    def initialize(id)
      @id = id
      @issues = []
    end

    # Adds an issue
    # @param [Issue] issue if nil then a keywords are expected
    # @return [Array<Issue>] the current list of issues
    # @see Issue#initialize for supported keyword arguments
    def add(issue = nil, **args)
      unless issue
        args[:name] ||= id
        issue = Issue.new(args)
      end

      @issues << issue
    end
    alias_method :<<, :add

    # @return [TrueClass, FalseClass] true if there are no issues
    def empty?
      @issues.empty?
    end

    # Enumerates over every issue.
    #
    # @yieldparam [Issue] issue
    #
    # @return [Enumerator]
    #   If no block is given, an enumerator object will be returned.
    def each(&block)
      @issues.each(&block)
    end
  end
end
