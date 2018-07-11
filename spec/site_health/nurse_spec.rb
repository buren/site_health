# frozen_string_literal: true

require 'spec_helper'

require 'site_health/nurse'

RSpec.describe SiteHealth::Nurse do
  describe '#journal' do
    it 'returns hash with checked_urls and internal_server_error_urls keys' do
      expected = %i(checked_urls internal_server_error_urls)
      expect(described_class.new.journal.keys).to eq(expected)
    end
  end

  describe '#check_failed_url' do
    it 'adds url to failures' do
      url = 'https://jacobburenstam.com'
      nurse = described_class.new
      nurse.check_failed_url(url)

      expect(nurse.failures).to eq([url])
    end
  end

  describe '#check_page'
  describe '#lab_results'
end
