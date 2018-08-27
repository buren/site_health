# frozen_string_literal: true

module SiteHealth
  # Checks for XML-errors (backed by the excellent Nokogiri gem)
  class XML < Checker
    name 'xml'
    types 'xml'

    def check
      errors = page.doc.errors.map(&:to_s)
      errors.each do |error|
        add_issue(title: 'XML error', detail: error, severity: :major, priority: :high)
      end
      add_data(errors: errors)
    end
  end

  SiteHealth.register_checker(XML)
end
