# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SiteHealth::Issues do
  describe '#add' do
    context 'when given keyword arguments' do
      it 'construct an Issue instance from those arguments' do
        issues = described_class.new(nil)
        issues.add(code: 1, title: 'Wat!')

        expect(issues.first).to be_a(SiteHealth::Issue)
      end
    end

    context 'when given keyword arguments' do
      it 'construct an Issue instance from those arguments' do
        issues = described_class.new('foo')
        issues.add(code: 1, title: 'Wat!')

        issue = issues.first
        expect(issue).to be_a(SiteHealth::Issue)
        expect(issue.name).to eq('foo')
      end
    end
  end

  describe 'enumerable' do
    context 'when given only block' do
      it 'yields each element' do
        issues = described_class.new(nil)
        issues.add(title: '1')
        issues.add(title: '2')

        expect(issues.map(&:title).to_a).to eq(%w[1 2])
      end
    end
  end
end