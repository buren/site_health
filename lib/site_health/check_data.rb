# frozen_string_literal: true

module SiteHealth
  class CheckData
    include Enumerable

    def initialize
      @data = {}
    end

    def [](key)
      @data[key]
    end

    # Adds data
    # @param [Hash] the hash to be added
    # @return [Hash] the current data
    def add(hash)
      @data.merge!(hash)
    end

    # @return [TrueClass, FalseClass] true if there is no data
    def empty?
      @data.empty?
    end

    def each(&block)
      @data.each(&block)
    end

    def to_h
      @data.to_h
    end
  end
end
