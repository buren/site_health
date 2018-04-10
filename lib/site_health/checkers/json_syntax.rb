require "json"

module SiteHealth
  # Checks if JSON syntax is valid
  class JSONSyntax < Checker
    name "json_syntax"
    types "json"

    def check
      # @return [String] the error message or "OK" if syntax is valid
      data = begin
        JSON.parse(page.body)
        'OK'
      rescue ::JSON::ParserError => e
        e.message
      end

      add_data(parsing: data)
    end
  end
end
