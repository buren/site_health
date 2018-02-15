# SiteHealth [![Build Status](https://travis-ci.org/buren/site_health.svg?branch=master)](https://travis-ci.org/buren/site_health)

:warning: Project is still experimental, API will change (a lot) without notice.

Crawl a site and check various health indicators, such as:

- Server errors
- HTTP errors
- Invalid HTML/XML/JSON
- Missing HTML title

## Installation

Add this line to your application's Gemfile:

```ruby
gem "site_health"
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install site_health

## Usage

```ruby
nurse = SiteHealth.check("https://example.com")
```

## Configuration

```ruby
SiteHealth.configure do |config|
  # Override default checkers
  config.checkers = [
    SiteHealth::JSON,
    SiteHealth::HTML
  ]
  # You can also register additional checkers
  config.register_checker YourCustomChecker
end
```

__Add your own checker__:

```ruby
class ProfanityChecker < SiteHealth::Checker
  def call
    page.body.include?("shit")
  end

  def name
    "profanity"
  end

  # content types the checker should run on
  def types
    %i[html json xml css javascript]
  end
end
```

__Configure HTMLProofer__:
```ruby
SiteHealth.configure do |config|
  config.html_proofer do |proofer_config|
    proofer_config.log_level = :info
    proofer_config.check_opengraph = false
  end
end
```

__Configure W3C HTML/CSS validator__:
```ruby
SiteHealth.configure do |config|
  config.w3c_validators do |w3c_config|
    w3c_config.css_uri = 'http://localhost:8888/check'
    w3c_config.html_uri = 'http://localhost:8888/check'
  end
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/buren/site_health.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

---

## TODO

- Result formats `#to_json` (maybe `#to_csv`, `#to_html` too)
- Add logger support
- Checkers
  * canonical URL
  * http vs https links
  * links matching a pattern
  * validate JavaScript (hm... might be totally out of scope or maybe there is a gem or public API somewhere?)
