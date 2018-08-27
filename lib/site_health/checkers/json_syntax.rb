# frozen_string_literal: true

require 'json'

module SiteHealth
  # Checks if JSON syntax is valid
  class JSONSyntax < Checker
    name 'json_syntax'
    types 'json'
    issue_types(
      parse_error: {
        title: 'JSON parse error',
        severity: :major,
        priority: :high,
      }
    )

    protected

    def check
      JSON.parse(page.body)
    rescue ::JSON::ParserError => e
      add_issue_type(:parse_error, detail: e.message)
    end
  end

  SiteHealth.register_checker(JSONSyntax)
end
