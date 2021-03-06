# frozen_string_literal: true

module SiteHealth
  # Holds HTMLProofer configuration data
  class HTMLProoferConfiguration
    attr_reader :log_level, :error_sort

    attr_accessor :check_opengraph,
                  :check_html,
                  :check_external_hash,
                  :empty_alt_ignore,
                  :check_img_http,
                  :enforce_https,
                  :assume_extension,
                  :report_missing_names,
                  :report_invalid_tags,
                  :check_favicon,
                  :ignore_missing_internal_links

    # Valid log levels
    LOG_LEVELS = %i[
      debug
      info
      warn
      error
      fatal
    ].freeze

    # Valid error sorts
    ERROR_SORTS = %i[path desc status].freeze

    def initialize
      @log_level = :fatal
      @check_opengraph = true
      @check_html = true
      @check_external_hash = true
      @check_img_http = false
      @empty_alt_ignore = false
      @error_sort = :path
      @enforce_https = false
      @assume_extension = true
      @report_missing_names = true
      @report_invalid_tags = true
      @check_favicon = true
      @ignore_missing_internal_links = true
    end

    # @param [Symbol] level desired log level
    # @return [Symbol] current log level
    # @raise [ArgumentError] raises if invalid log level
    def log_level=(level)
      unless LOG_LEVELS.include?(level.to_sym)
        raise ArgumentError, "unknown log level :#{level}, must be one of: #{LOG_LEVELS.join(',')}" # rubocop:disable Metrics/LineLength
      end

      @log_level = level
    end

    # @param [Symbol] sort desired error sorting
    # @return [Symbol] current error sorting
    # @raise [ArgumentError] raises if invalid error sorting
    def error_sort=(sort)
      unless ERROR_SORTS.include?(sort.to_sym)
        raise ArgumentError, "unknown sort order :#{sort}, must be one of: #{ERROR_SORTS.join(',')}" # rubocop:disable Metrics/LineLength
      end

      @error_sort = sort
    end

    # @return [Hash] config as hash, only contains keys for ::HTMLProofer config
    def to_h
      {
        log_level: log_level,
        check_opengraph: check_opengraph,
        check_html: check_html,
        check_external_hash: check_external_hash,
        empty_alt_ignore: empty_alt_ignore,
        check_img_http: check_img_http,
        error_sort: error_sort,
        enforce_https: enforce_https,
        assume_extension: assume_extension,
        report_missing_names: report_missing_names,
        report_invalid_tags: report_invalid_tags,
        check_favicon: check_favicon,
      }
    end
  end
end
