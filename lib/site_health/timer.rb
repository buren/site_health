# frozen_string_literal: true

module SiteHealth
  class Timer
    attr_reader :started_at, :finished_at

    def self.start
      new.tap { |timer| timer.start }
    end

    def start
      @start = high_precision_time
      @started_at = Time.now
    end

    def finish
      @finish = high_precision_time
      @finished_at = Time.now
    end

    def diff
      unless @start && @finish
        fail(StandardError, "timer must have been started and finished")
      end

      @finish - @start
    end

    private

    def high_precision_time
      Process.clock_gettime(Process::CLOCK_MONOTONIC)
    end
  end
end
