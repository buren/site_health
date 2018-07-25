# frozen_string_literal: true

RSpec.describe SiteHealth do
  it 'has a version number' do
    expect(SiteHealth::VERSION).not_to be nil
  end

  describe '::require_optional_dependency' do
    it 'can require path' do
      loaded = SiteHealth.require_optional_dependency('set')

      # We don't really care if its been loaded before or not
      expect([true, false]).to include(loaded)
    end

    it 'raises LoadError with customized error when requiring file from non-installed gem' do
      message = "cannot load such file -- non_existing -- unable to require file from 'watman' gem -- please install it"
      expect do
        SiteHealth.require_optional_dependency('non_existing', gem_name: 'watman')
      end.to raise_error(LoadError, message)
    end
  end

  describe '#logger' do
    it 'returns the configured logger instance' do
      expect(SiteHealth.logger).to eq(SiteHealth.config.logger)
    end
  end
end
