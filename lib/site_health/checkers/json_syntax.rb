# frozen_string_literal: true

require 'json'

module SiteHealth
  # Checks if JSON syntax is valid
  class JSONSyntax < Checker
    name 'json_syntax'
    types 'json'

    def check
      message = begin
        JSON.parse(page.body)
        'OK'
      rescue ::JSON::ParserError => e
        e.message
      end

      add_issue(title: 'JSON parse error', detail: message, severity: :major, priority: :high)
      add_data(parsing: message)
    end
  end

  SiteHealth.register_checker(JSONSyntax)
end
