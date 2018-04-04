# frozen_string_literal: true

require "uri"

module SiteHealth
  class FacebookShareLink < Checker
    URL = 'https://www.facebook.com/sharer/sharer.php?u='

    # EXAMPLE:
    #   https://www.facebook.com/dialog/feed?
    #     app_id=145634995501895
    #     &display=popup&caption=An%20example%20caption
    #     &link=https%3A%2F%2Fdevelopers.facebook.com%2Fdocs%2Fdialogs%2F
    #     &redirect_uri=https://developers.facebook.com/tools/explorer
    #
    # StackOverflow
    #   https://stackoverflow.com/questions/20956229/has-facebook-sharer-php-changed-to-no-longer-accept-detailed-parameters
    #
    # Use dialog/feeds instead of sharer.php
    #   https://developers.facebook.com/docs/sharing/reference/feed-dialog
    #
    # Official answer from fb team
    #   https://developers.facebook.com/x/bugs/357750474364812/

    # @return [Boolean] determines whether the page returned a HTTP 404 status code
    def call
      unless look_like_facebook_share_url?
        return { code: :ignored, message: "does not look like a Facebook share URL" }
      end

      unless url.absolute?
        return {
          code: :invalid,
          message: "URL must be an absolute and include http(s)://"
        }
      end

      if url.path.include?("/sharer")
        return deprecated_url_check
      end

      if url.path.include?("/dialog/feed")
        return check_url
      end

      {
        code: :invalid,
        message: "invalid URL see #TODO"
      }
    end

    def look_like_facebook_share_url?
      base_url = "#{url.host}#{url.path}"

      base_url.include?("facebook.com/sharer") ||
        base_url.include?("facebook.com/dialog/feed")
    end

    # @return [String] the name of the checker
    def name
      "facebook_share_link"
    end

    # @return [Array<Symbol>] list of page types the checker will run on
    def types
      %i[html]
    end

    private

    def query
      @query ||= URI.decode_www_form(url.query).to_h
    end

    def check_url
      # EXAMPLE:
      #   https://www.facebook.com/dialog/feed?
      #     app_id=145634995501895
      #     &display=popup&caption=An%20example%20caption
      #     &link=https%3A%2F%2Fdevelopers.facebook.com%2Fdocs%2Fdialogs%2F
      #     &redirect_uri=https://developers.facebook.com/tools/explorer
      #
      # required params: app_id, display(=page/popup),redirect_uri

      %w[app_id display redirect_uri].each do |name|
        unless query.key?(name)
          return {
            code: :invalid,
            message: "invalid URL"
          }
        end
      end

      unless query["display"] == "page" || query["display"] == "popup"
        return {
          code: :invalid,
          message: "invalid URL"
        }
      end

      if query["link"] && invalid_url?(query["link"])
        return {
          code: :invalid,
          message: "link-param must be a valid URL"
        }
      end

      {
        code: :valid,
        message: "URL is valid"
      }
    end


    def deprecated_url_check
      unless url.path.include?('/sharer/sharer.php')
        return {
          code: :invalid,
          message: "wrong sharer path [DEPCREATED]"
        }
      end

      unless valid_url?(query['u'])
        return {
          code: :invalid,
          message: "u-param must be a valid url [DEPCREATED]"
        }
      end

      {
        code: :valid,
        message: "[DEPCREATED] this has been deprecated, please see.."
      }
    end

    def valid_url?(url)
      decoded_url = URI.decode(url)
      URI.parse(decoded_url).absolute?
    rescue URI::InvalidURIError
      false
    end
  end
end
