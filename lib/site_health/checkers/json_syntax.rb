require "json"

module SiteHealth
  # Checks if JSON syntax is valid
  class JSONSyntax < Checker
    # @return [String] the error message or "OK" if syntax is valid
    def call
      JSON.parse(page.body)
      'OK'
    rescue ::JSON::ParserError => e
      e.message
    end

    # @return [String] the name of the checker
    def name
      "json_syntax"
    end

    # @return [Array<Symbol>] list of page types the checker will run on
    def types
      %i[json]
    end
  end
end
