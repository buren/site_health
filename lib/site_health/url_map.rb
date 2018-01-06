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

    def each(&block)
      @data.each do |key, value|
        yield(key, value) if block_given?
      end
    end

    def [](key)
      @data[key.to_s]
    end

    def []=(key, value)
      @data[key.to_s] = value
    end

    def to_h
      @data
    end
  end
end
