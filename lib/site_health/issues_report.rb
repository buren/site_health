# frozen_string_literal: true

require 'csv'
require 'json'
require 'site_health/issue'

module SiteHealth
  class IssuesReport
    attr_writer :fields

    def initialize(issues)
      @issues = issues
      @fields = Issue.fields
      @select_block = proc { true }
      yield(self) if block_given?
    end

    def fields=(fields)
      @fields = fields.map(&:to_sym)
    end

    def select(&block)
      @select_block = block
    end

    def to_a
      issues = []
      each { |data| issues << data }
      issues
    end

    def to_csv
      CSV.generate do |csv|
        csv << @fields
        each { |data| csv << data.values_at(*@fields) }
      end
    end

    def to_json
      JSON.dump(to_a)
    end

    private

    def each
      @issues.each do |issue|
        next unless @select_block.call(issue)

        hash = issue.to_h.select { |k| @fields.include?(k) }
        yield(hash)
      end
    end
  end
end
