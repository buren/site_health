module SiteHealth
  class PageSpeedSummarizer
    def initialize(data)
      @data = data
    end

    def to_csv
      to_matrix.map { |row| row.join(',') }.join("\n")
    end

    def to_matrix
      header = %w[
        url
        total_speed_score
        css_kb
        html_kb
        image_kb
        javascript_kb
        other_kb
        total_kbytes
        number_hosts
        number_js_resources
        number_css_resources
        number_resources
        number_static_resources
        started_at
        finished_at
        runtime_in_seconds
      ]
      rows = @data.map do |url, data|
        pagespeed_data = data.dig(:checks, :google_page_speed)
        next unless pagespeed_data

        url = data[:url]
        started_at = data[:started_at]
        finished_at = data[:finished_at]
        runtime = data[:runtime_in_seconds]

        build_row(url, runtime, started_at, finished_at, pagespeed_data)
      end.reject(&:nil?)

      [header] + rows
    end

    def build_row(url, runtime_in_seconds, started_at, finished_at, pagespeed_data)
      stats = pagespeed_data[:page_stats]

      kbytes_columns = [
        bytes_to_kb(stats[:css_response_bytes]),
        bytes_to_kb(stats[:html_response_bytes]),
        bytes_to_kb(stats[:image_response_bytes]),
        bytes_to_kb(stats[:javascript_response_bytes]),
        bytes_to_kb(stats[:other_response_bytes])
      ]
      kbytes_columns << kbytes_columns.sum

      host_columns = [
        stats[:number_hosts],
        stats[:number_js_resources],
        stats[:number_css_resources],
        stats[:number_resources],
        stats[:number_static_resources]
      ]

      total_speed_score = pagespeed_data.dig(:rule_groups, :SPEED, :score)
      [url, total_speed_score] + kbytes_columns + host_columns + [started_at, finished_at, runtime_in_seconds]
    end

    def bytes_to_kb(bytes, round: 1)
      (bytes / 1024.0).round(round)
    end
  end
end
