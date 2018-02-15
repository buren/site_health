require 'google/apis/pagespeedonline_v2'

module SiteHealth
  class GooglePageSpeed < Checker
    Pagespeedonline = Google::Apis::PagespeedonlineV2
    PagespeedService = Pagespeedonline::PagespeedonlineService

    # @return [Google::Apis::PagespeedonlineV2::Result, nil] Google page speed result
    def call
      # TODO: Returning an object might cause problems with JSON::dump, since that
      # does not recursivly run #to_h on all objects (or does it?)
      perform_request
    end

    # @return [Google::Apis::PagespeedonlineV2::Result, nil] Google page speed result
    def perform_request(strategy: "desktop", api_key: config.google_page_speed_api_key)
      service = PagespeedService.new
      service.key = api_key

      begin
        service.run_pagespeed(
          page.url.to_s,
          locale: 'en',
          strategy: strategy
        ).to_h # TODO: Remove #to_h
      rescue Google::Apis::ClientError => e
        # Google::Apis::ClientError: noDocumentLoaded: The URL was fetched, but nothing
        # was rendered. Ensure that the URL points to an HTML page that loads
        # successfully in a web browser.
        puts "[ERROR] #{page.url.to_s} failed: #{e.message}"
      rescue Google::Apis::ServerError => e
        puts "[ERROR] #{page.url.to_s} failed: #{e.message}"
      end
    end

    # @return [String] the name of the checker
    def name
      'google_page_speed'
    end
  end
end
