require "spidr"
require "html-proofer"

require "site_health/version"
require "site_health/configuration"

require "site_health/key_struct"
require "site_health/url_map"

require "site_health/checkers/checker"
require "site_health/checkers/css"
require "site_health/checkers/html"
require "site_health/checkers/json"
require "site_health/checkers/xml"

require "site_health/nurse"

module SiteHealth
  def self.check(site)
    nurse = Nurse.new

    Spidr.site(site) do |spider|
      spider.every_link { |origin, dest| nurse.add_link(origin, dest) }
      spider.every_failed_url { |url| nurse.add_failed_url(url) }
      spider.every_page { |page| nurse.add_page(page) }
    end

    nurse.journal
  end

  def self.configure
    @configuration ||= Configuration.new
    yield(@configuration) if block_given?
    @configuration
  end

  def self.config
    configure
  end
end
