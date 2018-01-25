require "spec_helper"
require "site_health/event_emitter"

TestEventEmitter = SiteHealth::EventEmitter.define(:data_point)

RSpec.describe TestEventEmitter do
  describe "#initialize" do
    it "yields self to block" do
      event = nil

      event_handler = described_class.new do |handler|
        event = handler
      end

      expect(event).to eq(event_handler)
    end
  end


  describe "#data_point event" do
    it "can register and emit event" do
      result = nil

      handler = described_class.new do |on|
        on.every_data_point { |data| result = data }
      end

      data = 2
      handler.emit_data_point(data)

      expect(result).to eq(data)
    end
  end
end
