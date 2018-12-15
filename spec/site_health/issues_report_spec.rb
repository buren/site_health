# frozen_string_literal: true

require 'spec_helper'

require 'site_health/issues_report'

RSpec.describe SiteHealth::IssuesReport do
  let(:base_data) do
    {
      name: 'name',
      code: :watman,
      title: 'is invalid',
      detail: 'a detail',
      severity: :major,
      priority: :high,
      url: 'https://example.com',
      links: [{ href: 'http://example.com', about: 'just an example' }],
      meta: { extra: :data },
    }
  end

  let(:issues) do
    [
      SiteHealth::Issue.new(base_data),
      SiteHealth::Issue.new(base_data.merge(priority: :medium)),
    ]
  end

  let(:report) do
    described_class.new(issues) do |r|
      r.fields = %i[code name title]
      r.select { |issue| issue.priority == :high }
    end
  end

  describe '#to_a' do
    it 'returns report as an array' do
      expected = [{ name: 'name', code: :watman, title: 'is invalid' }]
      expect(report.to_a).to eq(expected)
    end
  end

  describe '#to_csv' do
    it 'generates correct CSV' do
      expected = <<~CSV
        code,name,title
        watman,name,is invalid
      CSV

      expect(report.to_csv).to eq(expected)
    end
  end

  describe '#to_json' do
    it 'generates correct JSON' do
      expected = '[{"name":"name","code":"watman","title":"is invalid"}]'
      expect(report.to_json).to eq(expected)
    end
  end
end
