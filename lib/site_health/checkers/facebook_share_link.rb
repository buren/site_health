# frozen_string_literal: true

require 'uri'

module SiteHealth
  class FacebookShareLink < Checker
    DOC_URL = 'https://developers.facebook.com/docs/sharing/reference/feed-dialog'
    DOC_REF = "See Facebooks documentation at #{DOC_URL}."
    DEPRECATION_NOTICE = <<~DEPNOTICE
      [DEPCREATED]
      StackOverflow
       https://stackoverflow.com/questions/20956229/has-facebook-sharer-php-changed-to-no-longer-accept-detailed-parameters
      Use dialog/feeds instead of sharer.php
       https://developers.facebook.com/docs/sharing/reference/feed-dialog
      Official answer from fb team
       https://developers.facebook.com/x/bugs/357750474364812/
    DEPNOTICE

    name 'facebook_share_link'
    types 'html'
    issue_types({
      _default: {
        title: 'URL Invalid',
        links:  [{ href: DOC_URL }],
      },
      not_absolute_url: {
        detail: "URL must be absolute. #{DOC_REF}",
      },
      app_id_query_param: {
        detail: "app_id query param invalid. #{DOC_REF}",
      },
      display_query_param: {
        detail: "display query param invalid. #{DOC_REF}",
      },
      link_query_param: {
        detail: "link query param invalid - must be a valid URL. #{DOC_REF}",
      },
      redirect_uri_query_param: {
        detail: "redirect_uri query param invalid - must be a valid URL. #{DOC_REF}",
      },
      deprecated_url_style: {
        title: 'URL-style depcreated',
        detail: "This style of Facebook share URL has been deprecated. #{DOC_URL}\n#{DEPRECATION_NOTICE}", # rubocop:disable Metrics/LineLength
      },
      sharer_path: {
        detail: "Wrong sharer path. #{DOC_URL}\n#{DEPRECATION_NOTICE}",
      },
      u_query_param: {
        detail: "u query param must be a valid URL. #{DOC_URL}\n#{DEPRECATION_NOTICE}",
      },
    })

    def should_check?
      return false unless super
      return false unless look_like_facebook_share_url?
      true
    end

    protected

    def check
      unless url.absolute?
        temp_url = url.to_s.start_with?('//') ? URI.parse("http:#{url}") : url

        unless temp_url.absolute?
          return add_issue_type(:not_absolute_url)
        end
      end

      if url.path.include?('/share')
        return check_url_deprecated
      end

      check_url
    end

    # @return [Boolean] true if the link looks like a Facebook share URL
    def look_like_facebook_share_url?
      base_url = "#{url.host}#{url.path}"

      base_url.include?('facebook.com/share') ||
        base_url.include?('facebook.com/dialog/feed')
    end

    private

    def query
      @query ||= URI.decode_www_form(url.query.to_s).to_h
    end

    def check_url
      unless query.key?('app_id')
        add_issue_type(:app_id_query_param)
      end

      # IIRC the only valid values for a regular web page are page and popup (not sure though..)
      unless query['display'] == 'page' || query['display'] == 'popup'
        add_issue_type(:display_query_param)
      end

      if query['link'] && !Link.valid?(query['link'])
        add_issue_type(:link_query_param)
      end

      if query['redirect_uri'] && !Link.valid?(query['redirect_uri'])
        add_issue_type(:redirect_uri_query_param)
      end
    end

    def check_url_deprecated
      add_issue_type(:deprecated_url_style)

      unless url.path.include?('/sharer/sharer.php') || url.path.include?('/sharer.php')
        add_issue_type(:sharer_path)
      end

      unless Link.valid?(query['u'])
        add_issue_type(:u_query_param)
      end
    end
  end

  SiteHealth.register_checker(FacebookShareLink)
end
