require "site_health/version"

require "site_health/key_struct"
require "site_health/url_map"

require "site_health/check"

module SiteHealth
  def self.check(site)
    Check.call(site: site)
  end
end
