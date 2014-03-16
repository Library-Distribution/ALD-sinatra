require_relative '../app'
require 'test/unit'
require 'rack/test'
require 'rexml/document'

class VersionTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_json
    get '/version', {}, 'HTTP_ACCEPT' => 'application/json'

    assert last_response.ok?, 'Could not retrieve version (in application/json)'
    assert_equal({ "version" => ALD::VERSION }, JSON.parse(last_response.body), "Version (in json) is invalid: '#{last_response.body}'")
  end

  def test_xml
    get '/version', {}, 'HTTP_ACCEPT' => 'application/xml'

    assert last_response.ok?, 'Could not retrieve version (in application/xml)'

    data = nil
    assert_nothing_raised "Failed to parse version (XML): '#{last_response.body}'" do
      data = REXML::Document.new last_response.body
    end

    assert !data.root.has_elements?,                        "Unexpected child elements in version (XML)"
    assert_equal ALD::VERSION, data.root.text,              "Version (in XML) is invalid: '#{data.root.text}'"
    assert_equal 1,            data.root.attributes.length, "#{data.root.attributes.length-1} unexpected attributes in version (XML)" # 1 attribute for XML namespace declaration
  end

  def test_xml_alias
    get '/version', {}, 'HTTP_ACCEPT' => 'application/xml'
    first_body = last_response.body
    get '/version', {}, 'HTTP_ACCEPT' => 'text/xml'

    assert last_response.ok?, 'Could not retrieve version (in text/xml)'
    assert_equal first_body, last_response.body, 'Version responses for application/xml and text/xml differ'
  end
end