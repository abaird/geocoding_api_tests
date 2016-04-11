require_relative '../load_lib'
require 'geocoding_api'

require 'rspec'
require 'vcr'
require 'airborne'
require 'cgi'

VCR.configure do |config|
  config.cassette_library_dir = 'fixtures/vcr_cassettes'
  config.hook_into :webmock
  config.configure_rspec_metadata!
end

RSpec.configure do |config|
  config.around(:each) do |ex|
    if ex.metadata.key?(:vcr)
      ex.run
    else
      WebMock.allow_net_connect!
      VCR.turned_off { ex.run }
      WebMock.disable_net_connect!
    end
  end

  def send_query(args)
    get GeocodingApi::Query.new(args).url
    resp = GeocodingApi::Response.new(json_body)
    expect(resp.status).to eq 'OK'
    resp
  end

  def send_error_query(args)
    get GeocodingApi::Query.new(args).url
    GeocodingApi::Response.new(json_body)
  end
end
