# frozen_string_literal: true

module SiteHealth
  # Hash-like data structure that holds URI as keys and can be accessed using
  # an URI instance or the String representation
  class UrlMap
    include Enumerable

    def initialize
      @data = if block_given?
                Hash.new { |hash, key| hash[key] = yield }
              else
                {}
              end
    end

    # @yieldparam [Object] value for key
    # @return [Enumerator] data
    def each
      @data.each do |key, value|
        yield(key, value) if block_given?
      end
    end

    # @return [Object] value for key
    def [](key)
      @data[key.to_s]
    end

    # Sets value for key
    # @return [Object] value for key
    def []=(key, value)
      @data[key.to_s] = value
    end

    # @return [Hash] hash representation of data
    def to_h
      @data
    end
  end
end
