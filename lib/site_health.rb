require "spidr"
require "w3c_validators"
require "site_health/version"

require "site_health/key_struct"
require "site_health/url_map"

require "site_health/journals/css_journal"
require "site_health/journals/html_journal"
require "site_health/journals/xml_journal"
require "site_health/journals/w3c_journal"

require "site_health/checkers/css_page"
require "site_health/checkers/html_page"
require "site_health/checkers/xml_page"

module SiteHealth
  def self.check(site)
    Check.call(site: site)
  end

  class Check
    def self.call(**args)
      new(**args).call
    end

    BrokenLinkJournal = KeyStruct.new(:url, :exists_on)

    HTTPCodeJournal = KeyStruct.new(:url, :code)
    class HTTPCodeJournal
      def error?
        code >= 400
      end
    end

    ChecksJournal = KeyStruct.new(
      :urls,
      :missing_html_title,
      :broken_urls,
      :http_error_urls,
      :html_error_urls,
      :html_warning_urls,
      :xml_error_urls,
      :css_error_urls,
      :css_warning_urls
    )

    attr_reader :site

    def initialize(site:)
      @site = site
    end

    def call
      url_map = UrlMap.new(default: [])
      urls = UrlMap.new(default: {})

      missing_html_title = []
      http_error_urls = []
      html_error_urls = []
      html_warning_urls = []
      xml_error_urls = []
      css_error_urls = []
      css_warning_urls = []

      spider = Spidr.site(site) do |spider|
        spider.every_link do |origin, destination|
          url_map[destination] << origin
        end

        spider.every_page do |page|
          code_journal = HTTPCodeJournal.new(url: page.url, code: page.code)
          http_error_urls << code_journal if code_journal.error?
          urls[page.url][:code] = page.code

          if page.css?
            result = Checkers::CSSPage.check(page)
            xml_error_urls << result if result.errors?
            urls[page.url][:css] = result
          end

          if page.xml?
            result = Checkers::XMLPage.check(page)
            xml_error_urls << result if result.errors?
            urls[page.url][:xml] = result
          end

          if page.html?
            result = Checkers::HTMLPage.check(page)
            missing_html_title << result if result.missing_title?
            html_error_urls << result if result.errors?
            urls[page.url][:html] = result
          end
        end
      end

      spider.visited_urls.map do |url|
        urls[url][:links_to] = url_map[url]
      end

      http_error_urls = map_http_error_urls(http_error_urls, url_map)
      broken_urls = broken_links(spider, url_map) + http_error_urls

      ChecksJournal.new(
        urls: urls,
        missing_html_title: missing_html_title,
        broken_urls: broken_urls,
        http_error_urls: http_error_urls,
        html_error_urls: html_error_urls,
        html_warning_urls: html_warning_urls,
        xml_error_urls: xml_error_urls,
        css_error_urls: css_error_urls,
        css_warning_urls: css_warning_urls
      )
    end

    def validate_css_page(page, errors)
      css_checker = Checkers::CSSPage.new(page)
      result = css_checker.check
      return unless result.errors?

      result
    end

    def map_http_error_urls(urls, url_map)
      urls.map do |failed_url|
        BrokenLinkJournal.new(url: failed_url, exists_on: url_map[failed_url])
      end
    end

    # Finds all pages which have broken links:
    def broken_links(spider, url_map)
      # FIXME: spider#failures only returns timeout errors etc and not HTTP error status codes..
      #        so we need to have 2 types of "failed" URLs
      spider.failures.map do |failed_url|
        BrokenLinkJournal.new(url: failed_url, exists_on: url_map[failed_url])
      end
    end

    # @return [W3CValidators::Results]
    # @raise [W3CValidators::ValidatorUnavailable] the service is offline or returns 400 Bad Request
    # @see https://github.com/w3c-validators/w3c_validators/issues/39 we really want to use #validate_text instead of #validate_uri but due to the linked issue thats not possible
    def validate_html(html_url)
      validator = W3CValidators::NuValidator.new
      validator.validate_uri(html_url)
    end
  end
end
