module SiteHealth
  HTMLJournal = KeyStruct.new(:page, :url, :errors, :warnings, :missing_title)
  class HTMLJournal
    def missing_title?
      missing_title
    end

    def errors?
      errors.any?
    end

    def warnings?
      warnings.any?
    end
  end
end
