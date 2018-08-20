# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SiteHealth::Issue do
  describe '#initialize' do
    it 'can be initialized with minimal attributes' do
      issue = SiteHealth::Issue.new(name: 'name', code: :watman, title: 'invalid')

      expect(issue.code).to eq(:watman)
      expect(issue.title).to eq('invalid')
    end

    it 'raises error when passed invalid link' do
      links = [{ some: :thing }]

      expect do
        SiteHealth::Issue.new(
          name: 'name',
          code: :watman,
          title: 'is invalid',
          links: links
        )
      end.to raise_error(ArgumentError)
    end

    it 'raises *no* error when passed valid link' do
      links = [{ href: 'https://example.com' }]

      issue = SiteHealth::Issue.new(
        name: 'name',
        code: :watman,
        title: 'is invalid',
        links: links
      )
      expect(issue.code).to eq(:watman)
    end

    it 'raises error when passed unknown priority' do
      expect do
        SiteHealth::Issue.new(
          name: 'name',
          code: :watman,
          title: 'is invalid',
          priority: :watman
        )
      end.to raise_error(ArgumentError)
    end

    it 'raises *no* error when passed known priority' do
      issue = SiteHealth::Issue.new(
        name: 'name',
        code: :watman,
        title: 'is invalid',
        priority: :high
      )
      expect(issue.priority).to eq(:high)
    end

    it 'raises error when passed unknown severity' do
      expect do
        SiteHealth::Issue.new(
          name: 'name',
          code: :watman,
          title: 'is invalid',
          severity: :watman
        )
      end.to raise_error(ArgumentError)
    end

    it 'raises *no* error when passed known severity' do
      issue = SiteHealth::Issue.new(name: 'name', code: :watman, title: 'is invalid', severity: :major)
      expect(issue.severity).to eq(:major)
    end
  end

  describe '#to_h' do
    it 'returns a Hash representation of the object' do
      issue = SiteHealth::Issue.new(
        name: 'name',
        code: :watman,
        title: 'is invalid',
        detail: 'a detail',
        severity: :major,
        priority: :high,
        url: 'https://example.com',
        links: [{ href: 'http://example.com', about: 'just an example' }],
        meta: { extra: :data }
      )

      expected = {
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

      expect(issue.to_h).to eq(expected)
    end
  end
end
