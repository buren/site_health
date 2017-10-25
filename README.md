# SiteHealth

:warning: Project is still experimental, API will change (a lot) without notice.

Crawl a site and check various health indicators, such as:

- HTTP error status
- Invalid HTML/CSS/XML
- Missing HTML page title
- Broken links

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
journal = SiteHealth.check("https://example.com")

# HTML
journal.missing_html_title # List of URLs that are missing the HTML title
journal.html_error_urls # List of URLs with HTML errors in them

# CSS
journal.css_error_urls # List of URLs with CSS errors in them

# XML
journal.xml_error_urls # List of URLs with XML errors in them

# Broken URLs
broken = journal.broken_urls.first
broken.url # The URL that failed
broken.exists_on # Array of URLs where the broken URL was present

# HTTP
journal.http_error_urls # All URLs with HTTP status code >= 400
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

- Implement `ChecksJournal#to_json` (maybe `#to_csv`, `#to_html` too)
- Add logger support
- Checkers
  * canonical URL
  * http vs https links
  * links matching a pattern
  * validate JavaScript (hm... might be totally out of scope or maybe there is a public API somewhere?)
  * validate JSON
