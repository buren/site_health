# frozen_string_literal: true

require 'csv'
require 'json'
require 'site_health/issue'

module SiteHealth
  class IssuesReport
    attr_writer :fields

    def initialize(nurse)
      @nurse = nurse
      @fields = Issue.fields
      @select_block = proc { true }
      yield(self) if block_given?
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

    def each(&block)
      @nurse.issues.each do |issue|
        next unless @select_block.call(issue)
        hash = issue.to_h.select { |k| @fields.include?(k) }
        block.call(hash)
      end
    end
  end
end
