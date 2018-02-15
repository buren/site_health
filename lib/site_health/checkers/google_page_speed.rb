require 'google/apis/pagespeedonline_v2'

module SiteHealth
  class GooglePageSpeed < Checker
    Pagespeedonline = Google::Apis::PagespeedonlineV2
    PagespeedService = Pagespeedonline::PagespeedonlineService

    attr_reader :service

    def initialize(*args, **keyword_args)
      super(*args, **keyword_args)

      @service = PagespeedService.new
      @service.key = api_key

      Google::Apis.logger = SiteHealth.logger
      Google::Apis.logger.level = SiteHealth.logger.level
    end

    # @return [Google::Apis::PagespeedonlineV2::Result, nil] Google page speed result
    def call
      perform_request
    end

    # @return [Google::Apis::PagespeedonlineV2::Result, nil] Google page speed result
    def perform_request(strategy: "desktop", api_key: config.google_page_speed_api_key)
      service.run_pagespeed(
        page.url.to_s,
        locale: 'en',
        strategy: strategy
      ).to_h
    rescue Google::Apis::ClientError => e
      # Google::Apis::ClientError: noDocumentLoaded: The URL was fetched, but nothing
      # was rendered. Ensure that the URL points to an HTML page that loads
      # successfully in a web browser.
      logger.error "#{page.url.to_s} failed: #{e.message}"
    rescue Google::Apis::ServerError => e
      logger.error "#{page.url.to_s} failed: #{e.message}"
    end

    # @return [String] the name of the checker
    def name
      'google_page_speed'
    end
  end
end
