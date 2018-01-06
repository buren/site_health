require "spidr"
require "html-proofer"

require "site_health/version"
require "site_health/configuration"

require "site_health/key_struct"
require "site_health/url_map"

require "site_health/checkers/checker"
require "site_health/checkers/default_checkers"
require "site_health/nurse"

# Top-level module/namespace
module SiteHealth
  # @return [Hash] journal data
  # @see Nurse#journal
  def self.check(site)
    nurse = Nurse.new

    # TODO: Add a way for adding checks for destination links
    Spidr.site(site) do |spider|
      spider.every_link { |origin, dest| nurse.check_link(origin, dest) }
      spider.every_failed_url { |url| nurse.check_failed_url(url) }
      spider.every_page { |page| nurse.check_page(page) }
    end

    nurse.journal
  end

  # @return [Configuration] the current configuration
  # @yieldparam [Configuration] the current configuration
  def self.configure
    @configuration ||= Configuration.new
    yield(@configuration) if block_given?
    @configuration
  end

  # @return [Configuration] the current configuration
  def self.config
    configure
  end
end
