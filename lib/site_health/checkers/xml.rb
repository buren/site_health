# frozen_string_literal: true

module SiteHealth
  # Checks for XML-errors (backed by the excellent Nokogiri gem)
  class XML < Checker
    name 'xml'
    types 'xml'
    issue_types(
      parse_error: {
        title: 'XML error',
        severity: :major,
        priority: :high,
      }
    )

    def check
      errors = page.doc.errors.map(&:to_s)
      errors.each do |error|
        add_issue_type(:parse_error, detail: error)
      end
    end
  end

  SiteHealth.register_checker(XML)
end
