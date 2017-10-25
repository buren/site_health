module SiteHealth
  HTMLJournal = KeyStruct.new(
    :page,
    :url,
    :errors,
    :warnings,
    :missing_title?,
    :redirect?
  )

  class HTMLJournal
    def errors?
      errors.any?
    end

    def warnings?
      warnings.any?
    end

    def code
      page.code
    end
  end
end
