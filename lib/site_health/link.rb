# frozen_string_literal: true

require "uri"

module SiteHealth
  class Link
    def self.valid?(*args, **kwargs)
      new(*args, **kwargs).valid?
    end

    attr_reader :uri, :url

    def initialize(url, decode: false)
      @url = decode_url(url, decode)
      @uri = safe_parse_url(@url)
      @valid = @uri.absolute?
    end

    def valid?
      @valid
    end

    private

    # @param [String] url
    # @param [Boolean] decode
    def decode_url(url, decode)
      return url.to_s if url.is_a?(URI)
      return URI.decode(url) if decode

      url
    end

    # @param [String] url
    def safe_parse_url(url)
      URI.parse(url)
    rescue URI::InvalidURIError
      URI.parse("")
    end
  end
end
