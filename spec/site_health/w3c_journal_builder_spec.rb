# frozen_string_literal: true

require 'spec_helper'
require 'site_health/w3c_journal_builder'

RSpec.describe SiteHealth::W3CJournalBuilder do
  describe '::build' do
    it 'returns an instance of W3CJournal' do
      expect(described_class.build(OpenStruct.new).class).to eq(SiteHealth::W3CJournal)
    end
  end
end
