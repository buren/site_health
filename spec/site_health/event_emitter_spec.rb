# frozen_string_literal: true

require 'spec_helper'
require 'site_health/event_emitter'

TestEventEmitter = SiteHealth::EventEmitter.define(:data_point)

RSpec.describe TestEventEmitter do
  describe '#initialize' do
    it 'yields self to block' do
      event = nil

      event_handler = described_class.new do |handler|
        event = handler
      end

      expect(event).to eq(event_handler)
    end
  end

  it 'raises NoMethodError when unknown #every_* method is called' do
    described_class.new do |on|
      expect do
        on.every_watman { |data| data }
      end.to raise_error(NoMethodError)
    end
  end

  it 'raises NoMethodError when unknown #emit_* method is called' do
    described_class.new do |on|
      expect do
        on.emit_watman { |w| w }
      end.to raise_error(NoMethodError)
    end
  end

  describe '#data_point event' do
    it 'can register and emit event' do
      result = nil

      handler = described_class.new do |on|
        on.every_data_point { |data| result = data }
      end

      data = 2
      handler.emit_data_point(data)

      expect(result).to eq(data)
    end

    it 'can emit event with #emit method' do
      result = nil

      handler = described_class.new do |on|
        on.every_data_point { |data| result = data }
      end

      data = 2
      handler.emit(:data_point, data)

      expect(result).to eq(data)
    end

    it 'can emit event with #emit_each method' do
      result = 0

      handler = described_class.new do |on|
        on.every_data_point { |value| result += value }
      end

      values = [2, 3, 4]
      handler.emit_each(:data_point, values)

      expect(result).to eq(values.inject(:+))
    end

    it 'raises ArgumentError unless block given' do
      described_class.new do |on|
        expect do
          on.every_data_point
        end.to raise_error(ArgumentError, 'block must be given!')
      end
    end
  end
end
