# frozen_string_literal: true

require 'spec_helper'
require 'site_health/checkers/facebook_share_link'

RSpec.describe SiteHealth::FacebookShareLink do
  describe '#should_check?' do
    %w[
      https://stackoverflow.com
      https://developers.facebook.com/docs/sharing
      https://www.facebook.com/shar
      https://www.facebook.com/dialog/
      https://www.example.com/sharer/sharer.php
    ].each do |url|
      it 'returns false for urls that does *not* look like Facebook share links' do
        page = mock_page(url: url, content_type: 'html')
        checker = SiteHealth::FacebookShareLink.new(page)

        expect(checker.should_check?).to eq(false)
      end
    end

    it 'returns true for url that looks like Facebook share links' do
      url = 'https://www.facebook.com/sharer/sharer.php'
      page = mock_page(url: url, content_type: 'html')
      checker = SiteHealth::FacebookShareLink.new(page)

      expect(checker.should_check?).to eq(true)
    end
  end

  describe '#call' do
    it 'ignores non-absolute urls' do
      url = 'facebook.com/sharer/sharer.php'
      page = mock_page(url: url)
      checker = SiteHealth::FacebookShareLink.new(page)
      checker.call

      expect(checker.issues.first.code).to eq(:invalid)
    end

    context 'URL that start with //' do
      it 'returns no issues for valid URL' do
        url = '//www.facebook.com/dialog/feed/?app_id=145634995501895&display=popup'
        page = mock_page(url: url)
        checker = SiteHealth::FacebookShareLink.new(page)
        checker.call

        expect(checker.issues).to be_empty
      end

      it 'returns issue for invalid URL' do
        url = '//www.facebook'
        page = mock_page(url: url)
        checker = SiteHealth::FacebookShareLink.new(page)
        checker.call

        expect(checker.issues).not_to be_empty
      end
    end

    context 'when using /dialog/feed path' do
      base_url = 'https://www.facebook.com/dialog/feed/'
      # VALID EXAMPLE:
      #   https://www.facebook.com/dialog/feed?
      #     app_id=145634995501895
      #     &display=popup&caption=An%20example
      #     &link=https%3A%2F%2Fdevelopers.facebook.com%2Fdocs%2Fdialogs%2F
      #     &redirect_uri=https://developers.facebook.com/tools/explorer

      it 'returns correct data' do
        url = "#{base_url}?app_id=145634995501895&display=popup"
        page = mock_page(url: url)
        checker = SiteHealth::FacebookShareLink.new(page)
        checker.call

        data = checker.data.to_h
        %i[started_at finished_at runtime_in_seconds].each { |key| data.delete(key) }
        expect(data).to eq({})
      end

      %W[
        #{base_url}?app_id=145634995501895&display=popup
        #{base_url}?app_id=145634995501895&display=popup&caption=An%20example&link=https%3A%2F%2Fdevelopers.facebook.com%2Fdocs%2Fdialogs%2F&redirect_uri=https://developers.facebook.com/tools/explorer
      ].each do |data|
        url, status = data

        it "returns #{status} for #{url}" do
          page = mock_page(url: url)
          checker = SiteHealth::FacebookShareLink.new(page)
          checker.call

          expect(checker.issues).to be_empty
        end
      end

      [
        # url, code
        ["#{base_url}?app_id=145634995501895&display=popup&link=developers.facebook.com%2Fdocs%2Fdialogs%2F", :link_invalid],
        ["#{base_url}?app_id=145634995501895&display=popup&redirect_uri=developers.facebook.com/tools/explorer", :redirect_uri_invalid],
        ["#{base_url}?app_id=145634995501895", :required_params_missing],
        ["#{base_url}?display=popup", :required_params_missing],
      ].each do |data|
        url, status = data

        it "returns #{status} for #{url}" do
          page = mock_page(url: url)
          checker = SiteHealth::FacebookShareLink.new(page)
          checker.call
          issue = checker.issues.detect { |i| i.code == status }

          expect(issue.code).to eq(status)
        end
      end
    end

    context 'when using *deprecated* /sharer/ path' do
      valid_base_url = 'https://www.facebook.com/sharer/sharer.php'
      share_url = 'http://example.com'
      bad_share_url = 'example.com'

      [
        # url, status
        ["#{valid_base_url}?u=#{share_url}", :deprecated],
        ["https://facebook.com/sharer/sharer.php?u=#{share_url}", :deprecated],
        ["http://facebook.com/sharer/sharer.php?u=#{share_url}", :deprecated],
        ["https://www.facebook.com/sharer.php?u=#{share_url}", :deprecated],
        ["https://www.facebook.com/share?u=#{share_url}", :invalid],
        ["#{valid_base_url}?u=#{bad_share_url}", :invalid],
      ].each do |data|
        url, status = data

        it "returns #{status} status for #{url}" do
          page = mock_page(url: url)
          checker = SiteHealth::FacebookShareLink.new(page)
          checker.call

          expect(checker.issues.first.code).to eq(status)
        end

        it "adds deprecated notice for #{url}" do
          page = mock_page(url: url)
          checker = SiteHealth::FacebookShareLink.new(page)
          checker.call
          title = checker.issues.first.title
          deprecated_notice = checker.class::DEPRECATION_NOTICE

          expect(title.include?(deprecated_notice)).to eq(true)
        end
      end
    end
  end
end
