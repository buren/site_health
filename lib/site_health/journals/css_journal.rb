module SiteHealth
  CSSJournal = KeyStruct.new(:page, :url, :errors, :warnings)
  class CSSJournal
    def errors?
      errors.any?
    end

    def warnings?
      warnings.any?
    end
  end
end
