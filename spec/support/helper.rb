module SpecHelper
  class MockHTTPResponse < OpenStruct
    def get_fields(field)
      return ['text/html'] if field == 'content-type'
      []
    end
  end

  def mock_test_page(name)
    body = File.read("spec/data/fake-site/#{name}")
    mock_page(body: body)
  end

  def mock_page(url: '', body:)
    response = MockHTTPResponse.new(body: body, to_hash: {})
    Spidr::Page.new(URI.parse(url), response)
  end
end