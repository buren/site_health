# frozen_string_literal: true

require "time"

module SiteHealth
  class Timer
    attr_reader :started_at, :finished_at

    def self.start
      new.tap { |timer| timer.start }
    end

    def self.measure(&block)
      new.tap { |timer| timer.measure(&block) }
    end

    def measure(&block)
      start
      yield
      finish
      self
    end

    def start
      @started = high_precision_time
      @started_at = Time.now
    end

    def finish
      @finished = high_precision_time
      @finished_at = Time.now
    end

    def diff
      fail(StandardError, "timer must be started") unless @started

      finish = @finished || high_precision_time
      finish - @started
    end

    private

    def high_precision_time
      Process.clock_gettime(Process::CLOCK_MONOTONIC)
    end
  end
end
