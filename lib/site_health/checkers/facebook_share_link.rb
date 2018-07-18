# frozen_string_literal: true

require 'uri'

module SiteHealth
  class FacebookShareLink < Checker
    name 'facebook_share_link'
    types 'html'

    DOC_URL = 'https://developers.facebook.com/docs/sharing/reference/feed-dialog'

    DEPRECATION_NOTICE = <<~DEPNOTICE
      [DEPCREATED]
      StackOverflow
       https://stackoverflow.com/questions/20956229/has-facebook-sharer-php-changed-to-no-longer-accept-detailed-parameters
      Use dialog/feeds instead of sharer.php
       https://developers.facebook.com/docs/sharing/reference/feed-dialog
      Official answer from fb team
       https://developers.facebook.com/x/bugs/357750474364812/
    DEPNOTICE

    def should_check?
      return false unless super
      return false unless look_like_facebook_share_url?
      true
    end

    protected

    def check
      unless url.absolute?
        temp_url = url.dup.tap { |u| u.scheme = 'http' }

        unless temp_url.absolute?
          title = "URL must be an absolute and include http(s):// or // see #{DOC_URL}"
          add_issue(code: :invalid, title: title)
          return
        end
      end

      if url.path.include?('/share')
        check_url_deprecated
        return
      end

      check_url
    end

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
      # check presence of required params
      unless query.key?('app_id') && query.key?('display')
        add_issue(code: :required_params_missing, title: 'invalid URL')
      end

      # IIRC the only valid values for a regular web page are (not sure though..)
      unless query['display'] == 'page' || query['display'] == 'popup'
        add_issue(code: :display_invalid, title: 'invalid URL')
      end

      if query['link'] && !Link.valid?(query['link'])
        add_issue(code: :link_invalid, title: 'link-param must be a valid URL')
      end

      if query['redirect_uri'] && !Link.valid?(query['redirect_uri'])
        add_issue(code: :redirect_uri_invalid, title: 'redirect_uri-param must be a valid URL')
      end
    end

    def check_url_deprecated
      unless url.path.include?('/sharer/sharer.php') || url.path.include?('/sharer.php')
        add_issue(code: :invalid, title: "wrong sharer path #{DEPRECATION_NOTICE}")
        return
      end

      unless Link.valid?(query['u'])
        add_issue(code: :invalid, title: "u-param must be a valid url #{DEPRECATION_NOTICE}")
        return
      end

      add_issue(code: :deprecated, title: "URL is valid, however: #{DEPRECATION_NOTICE}")
    end
  end

  SiteHealth.register_checker(FacebookShareLink)
end
