require "logger"

require "spidr"

require "site_health/version"
require "site_health/configuration"

require "site_health/key_struct"
require "site_health/url_map"
require "site_health/link"

require "site_health/checkers/checker"
require "site_health/nurse"

# Top-level module/namespace
module SiteHealth
  def self.require_optional_dependency(path, gem_name: nil)
    gem_name = path unless gem_name
    require path
  rescue LoadError => e
    message_parts = [
      e.message,
      "unable to require file from '#{gem_name}' gem",
      "please install it"
    ]
    raise(LoadError, message_parts.join(" -- "))
  end

  # @param [Checker] klass that inherits from Checker
  # @return [see SiteHealth#registered_checkers]
  def self.register_checker(klass)
    registered_checkers[klass.name.to_sym] = klass
    registered_checkers
  end

  # @return [Hash] all registered checkers
  def self.registered_checkers
    @checkers ||= {}
  end

  # @param [Symbol, String] name of the checker to be loaded
  # @return [Checker] loaded class that should inherits from Checker
  def self.load_checker(name)
    name_key = name.to_sym
    registered_checkers.fetch(name_key) do
      require "site_health/checkers/#{name}"
      registered_checkers[name_key]
    end
  end

  # @param [String] site to be checked
  # @param config [SiteHealth::Configuration] the configuration to use
  # @yieldparam [SiteHealth::Nurse] nurse (a.k.a agent)
  # @return [Hash] journal data
  # @see Nurse#journal
  def self.check(site, config: SiteHealth.config)
    nurse = Nurse.new(config: config)
    yield(nurse) if block_given?

    Spidr.site(site) do |spider|
      spider.every_failed_url { |url| nurse.check_failed_url(url) }
      spider.every_page { |page| nurse.check_page(page) }
    end

    nurse
  end

  # @param [Array<String>, String] urls to be checked
  # @param config [SiteHealth::Configuration] the configuration to use
  # @yieldparam [SiteHealth::Nurse] nurse (a.k.a agent)
  # @return [Hash] journal data
  # @see Nurse#journal
  def self.check_urls(urls, config: SiteHealth.config)
    nurse = Nurse.new(config: config)
    yield(nurse) if block_given?

    agent = Spidr::Agent.new

    Array(urls).each do |url|
      page = agent.get_page(url)

      if page.nil?
        nurse.check_failed_url(url)
        next
      end

      nurse.check_page(page)
    end

    nurse
  end

  # @see Configuration#logger
  def self.logger
    config.logger
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
