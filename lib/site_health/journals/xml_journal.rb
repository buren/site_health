module SiteHealth
  XMLJournal = KeyStruct.new(:page, :url, :errors)
  class XMLJournal
    def errors?
      errors.any?
    end
  end
end
