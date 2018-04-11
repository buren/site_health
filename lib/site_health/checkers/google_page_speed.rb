SiteHealth.require_optional_dependency(
  "google/apis/pagespeedonline_v2",
  gem_name: "google-api-client"
)

module SiteHealth
  class GooglePageSpeed < Checker
    name "google_page_speed"
    types "html"

    Pagespeedonline = Google::Apis::PagespeedonlineV2
    PagespeedService = Pagespeedonline::PagespeedonlineService

    attr_reader :service

    def initialize(*args, **keyword_args)
      super(*args, **keyword_args)

      @service = PagespeedService.new
      @service.key = config.google_page_speed_api_key

      Google::Apis.logger = logger
      Google::Apis.logger.level = logger.level if logger.level
    end

    protected

    def check
      result = perform_request
      add_data(result)
    end

    private

    # @return [Google::Apis::PagespeedonlineV2::Result, nil] Google page speed result
    def perform_request(strategy: "desktop")
      service.run_pagespeed(
        page.url.to_s,
        locale: config.locale,
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
  end

  SiteHealth.register_checker(GooglePageSpeed)
end
