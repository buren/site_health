# frozen_string_literal: true

require 'uri'

module SiteHealth
  class Link
    def self.valid?(*args)
      new(*args).valid?
    end

    attr_reader :uri, :url

    def initialize(url)
      @url = url
      @uri = safe_parse_url(@url)
      @valid = @uri.absolute?
    end

    def valid?
      @valid
    end

    private

    # @param [String] url
    def safe_parse_url(url)
      URI.parse(url)
    rescue URI::InvalidURIError
      URI.parse('')
    end
  end
end
