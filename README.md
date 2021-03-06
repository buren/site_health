# SiteHealth [![Build Status](https://travis-ci.org/buren/site_health.svg?branch=master)](https://travis-ci.org/buren/site_health)

:warning: Project is still experimental, API will change (a lot) without notice.

Crawl a site and check various health indicators, such as:

- Server errors
- HTTP errors
- Invalid HTML/XML/JSON
- Missing HTML title/description
- Missing image alt-attribute
- Google Pagespeed

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

[CLI usage](#cli).

Crawl and check site

```ruby
nurse = SiteHealth.check("https://example.com")
```

Check list of URLs
```ruby
nurse = SiteHealth.check_urls(["https://example.com"])
```

Write raw JSON result to file
```ruby
nurse = SiteHealth.check("https://example.com")
json = JSON.pretty_generate(nurse.journal)

File.write("result.json", json)
```

Each issue

```ruby
SiteHealth.check_urls(urls) do |nurse|
  nurse.clerk do |clerk|
    clerk.every_issue { |issue| puts "#{issue.severity}, #{issue.title}" }
  end
end
```

Simple issue reports
```ruby
nurse = SiteHealth.check("https://example.com")
report = SiteHealth::IssuesReport.new(nurse.issue) do |r|
  r.fields = %i[url title detail] # issue fields
  r.select { |issue| issue.url.include?('blog/') }
end

report.to_a
report.to_csv
report.to_json
```

Event handlers

```ruby
urls = ["https://example.com"]
nurse = SiteHealth.check_urls(urls) do |nurse|
  nurse.clerk do |clerk|
    clerk.every_journal do |journal, page|
      time_in_seconds = journal[:runtime_in_seconds]
      puts "Found page #{page.title} - #{page.url} (checks took #{time_in_seconds})"
    end

    clerk.every_check do |check|
      puts "Ran check: #{check.name}"
    end

    clerk.every_failed_url do |url|
      puts "Failed to fetch: #{url}"
    end
  end
end
```

Write page speed summary CSV

```ruby
nurse = SiteHealth.check("https://example.com")
summary = SiteHealth::PageSpeedSummarizer.new(nurse.journal)
File.write("page_size_summary.csv", summary.to_csv)
```

## Configuration

All configuration is optional.

```ruby
SiteHealth.configure do |config|
  # Override default checkers
  config.checkers = [:json_syntax, :html]

  # Configure logger
  config.logger = Logger.new(STDOUT).tap do |logger|
    logger.progname = 'SiteHealth'
    logger.level = Logger::INFO
  end

  # Configure HTMLProofer
  config.html_proofer do |proofer_config|
    proofer_config.log_level = :info
    proofer_config.check_opengraph = false
  end

  # Configure W3C HTML/CSS validator
  config.w3c_validators do |w3c_config|
    w3c_config.css_uri = 'http://localhost:8888/check'
    w3c_config.html_uri = 'http://localhost:8888/check'
  end
end
```

__Load non-default checkers__:

A few of the non-default checkers available in this gem require 3rd-party dependencies which aren't installed by default.

| Checker name       | Gem                |
| ------------------ | ------------------ |
| google_page_speed  | google-api-client  |
| html_proofer       | html-proofer       |
| w3c_html           | w3c_validators     |
| w3c_css            | w3c_validators     |

If you intend to use any of those checkers make sure to install the gem first. For example to use the `google_page_speed` checker add `google-api-client` to your Gemfile or install it manually with `gem install google-api-client`. Then you register the checker for use.

```ruby
SiteHealth.config.register_checker :google_page_speed
# LoadError is raised if google-api-client is *not* installed
```

__Add your own checker__:

```ruby
class ProfanityChecker < SiteHealth::Checker
  name "profanity"
  types %i[html json xml css javascript]

  def check
    add_data(profanity: {
      damn: page.body.include?(" damn "),
      shit: page.body.include?(" shit ")
    })
  end
end

# Then register it
SiteHealth.configure do |config|
  config.register_checker ProfanityChecker
end
```

## CLI

```
Usage: site_health --help
        --url=val0
        --fields=priority,title,url  Issue fields to include - by default all fields are included
        --output=result.csv          Output path, .csv or .json
        --stats-output=stats.csv     Stats output path, .csv or .json
        --[no-]progress              Print progress while running to STDOUT
    -h, --help                       How to use
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bundle exec rake` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/buren/site_health.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

---

## TODO

- Good way to render result/reports data
- Improve logger support
- Checkers
  * canonical URL
  * http vs https links
  * links matching a pattern
