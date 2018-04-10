# frozen_string_literal: true

require "spec_helper"
require "site_health/timer"

RSpec.describe SiteHealth::Timer do
  describe "::start" do
    it "returns an instance of timer" do
      expect(SiteHealth::Timer.start).to be_a(SiteHealth::Timer)
    end
  end

  describe "::measure" do
    it "yields to block and returns the timer" do
      timer = SiteHealth::Timer.measure { sleep 0.3 }

      expect(timer.diff > 0.3).to eq(true)
      expect(timer.diff < 0.35).to eq(true)
    end
  end

  describe "#start" do
    it "returns the time when it started" do
      time = Time.local(1990)
      timer = SiteHealth::Timer.new

      Timecop.freeze(time) do
        started_at = timer.start

        expect(started_at).to eq(time)
      end
    end
  end

  describe "#finish" do
    it "returns the time when it finished" do
      time = Time.local(1990)
      timer = SiteHealth::Timer.new
      timer.start

      Timecop.freeze(time) do
        finished_at = timer.finish

        expect(finished_at).to eq(time)
      end
    end
  end

  describe "#diff" do
    it "returns the diff in seconds" do
      time = Time.local(1990)
      timer = SiteHealth::Timer.new

      Timecop.freeze(time) do
        allow(Process).to receive(:clock_gettime).and_return(0)
        timer.start
        allow(Process).to receive(:clock_gettime).and_return(1)
        timer.finish

        expect(timer.diff).to eq(1)
      end
    end

    it "raises StandardError unless started" do
      timer = SiteHealth::Timer.new

      expect { timer.diff }.to raise_error(StandardError)
    end

    it "if not finished it returns the diff from the start time to current time" do
      time = Time.local(1990)
      timer = SiteHealth::Timer.new
      timer.start

      Timecop.freeze(time) do
        allow(Process).to receive(:clock_gettime).and_return(0)
        timer.start
        allow(Process).to receive(:clock_gettime).and_return(1)

        expect(timer.diff).to eq(1)
      end
    end
  end
end
