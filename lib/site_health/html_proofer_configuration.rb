module SiteHealth
	class HTMLProoferConfiguration
    attr_reader :log_level, :error_sort

    attr_accessor :check_opengraph,
                  :check_html,
                  :check_external_hash,
                  :empty_alt_ignore,
									:enforce_https,
									:external_only

    LOG_LEVELS = %i[
      debug
      info
      warn
      error
      fatal
    ].freeze

    ERROR_SORTS = %i[path desc status].freeze

    def initialize
      @log_level = :fatal
      @check_opengraph = true
      @check_html = true
      @check_external_hash = true
      @empty_alt_ignore = false
      @error_sort = :path
			@enforce_https = false
			@external_only = true
    end

    def log_level=(level)
      unless LOG_LEVELS.include?(level.to_sym)
        raise ArgumentError, "unknown log level :#{level}, must be one of: #{LOG_LEVELS.join(",")}"
      end

      @log_level = level
    end

    def error_sort=(sort)
      unless ERROR_SORTS.include?(sort.to_sym)
        raise ArgumentError, "unknown sort order :#{sort}, must be one of: #{ERROR_SORTS.join(",")}"
      end

      @error_sort = sort
    end

    def to_h
      {
        log_level: log_level,
        check_opengraph: check_opengraph,
        check_html: check_html,
        check_external_hash: check_external_hash,
        empty_alt_ignore: empty_alt_ignore,
        error_sort: error_sort,
				enforce_https: enforce_https,
				external_only: external_only
      }
    end
  end
end
