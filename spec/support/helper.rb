require "ostruct"

module SiteHealth
  module SpecHelper
    class MockHTTPResponse < KeyStruct.new(:code, :body, :to_hash, :content_type)
      def get_fields(field)
        return ['text/html'] if html?(field)
        return ['text/xml'] if xml?(field)
        return ['application/json'] if json?(field)

        []
      end

      def html?(field)
        field == 'content-type' && content_type == 'html'
      end

      def json?(field)
        field == 'content-type' && content_type == 'json'
      end

      def xml?(field)
        field == 'content-type' && content_type == 'xml'
      end
    end

    def mock_test_page(name)
      file_extension = name.split('.').last
      content_type = 'html' if file_extension == "html"
      content_type = 'json' if file_extension == "json"
      content_type = 'xml' if file_extension == "xml"

      body = File.read("spec/data/fake-site/#{name}")
      mock_page(body: body, content_type: content_type)
    end

    def nil_page
      OpenStruct.new(url: "", body: "")
    end

    def mock_page(url: '', code: 200, body:, content_type: nil)
      response = MockHTTPResponse.new(
        code: code,
        body: body,
        to_hash: {},
        content_type: content_type
      )
      Spidr::Page.new(URI.parse(url), response)
    end
  end
end
