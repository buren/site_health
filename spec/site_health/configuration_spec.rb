# frozen_string_literal: true

require 'spec_helper'

require 'site_health/configuration/configuration'

RSpec.describe SiteHealth::Configuration do
  let(:custom_checker) do
    Class.new { define_method(:check) { nil } }
  end

  describe '#w3c' do
    it 'returns an instance of W3CValidatorsConfiguration' do
      expect(described_class.new.w3c).to be_a(SiteHealth::W3CValidatorsConfiguration)
    end
  end

  describe '#html_proofer' do
    it 'returns an instance of HTMLProoferConfiguration' do
      expect(described_class.new.html_proofer).to be_a(SiteHealth::HTMLProoferConfiguration)
    end
  end

  describe '#checkers=' do
    it 'can reassign checkers' do
      config = described_class.new
      config.checkers = custom_checker

      expect(config.checkers).to eq([custom_checker])
    end
  end

  describe '#logger=' do
    it 'can set logger' do
      config = described_class.new
      config.logger = :wat

      expect(config.logger).to eq(:wat)
    end
  end

  describe '#register_checker' do
    it 'can add custom checker class' do
      config = described_class.new
      config.register_checker(custom_checker)

      expect(config.checkers).to include(custom_checker)
    end

    it 'can add checker from symbol' do
      config = described_class.new
      checker = config.register_checker(:json_syntax)

      expect(checker).to eq(SiteHealth::JSONSyntax)
    end

    it 'raises an error if given checker name checker class does *not* exist' do
      config = described_class.new
      expect do
        config.register_checker(:watman)
      end.to raise_error(LoadError)
    end

    it 'raises an error if checker class does *not* respond to #check' do
      my_checker_klass = Class.new

      config = described_class.new
      expect do
        config.register_checker(my_checker_klass)
      end.to raise_error(SiteHealth::Configuration::InvalidCheckerError)
    end
  end
end
