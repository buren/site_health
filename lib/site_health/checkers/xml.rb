module SiteHealth
  # Checks for XML-errors (backed by the excellent Nokogiri gem)
  class XML < Checker
    name "xml"
    types "xml"

    def check
      # @return [Array<String>] list of XML errors
      add_data(errors: page.doc.errors.map(&:to_s))
    end
  end
end
