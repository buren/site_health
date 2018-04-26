# frozen_string_literal: true

module SiteHealth
  class Issues
    include Enumerable

    def initialize
      @issues = []
    end

    # Adds an issue
    # @param [Issue] issue if nil then a keywords are expected
    # @return [Array<Issue>] the current list of issues
    # @see Issue#initialize for supported keyword arguments
    def add(issue = nil, **issue_args)
      @issues << issue || Issue.new(**args.merge(name: name))
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
