module SiteHealth
  class Journal
    attr_reader :page, :url, :warnings, :errors

    def initialize(page:, url:, warnings: [], errors: [])
      @page = page
      @url = url
      @warnings = warnings
      @errors = errors
    end

    def code
      page.code
    end

    def warnings?
      warnings.any?
    end

    def errors?
      errors.any?
    end
  end
end
