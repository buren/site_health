# frozen_string_literal: true

module SiteHealth
  # Checks if page is a redirect (works with HTTP 3XX status and HTML body redirects)
  class Redirect < Checker
    name 'redirect'

    protected

    def check
      add_data(redirect: page.redirect?)
    end
  end

  SiteHealth.register_checker(Redirect)
end
