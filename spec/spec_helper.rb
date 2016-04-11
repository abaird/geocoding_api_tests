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

  # Convenience queries that handle putting together a query and sending
  # it to Google. The first method checks the OK response, the second
  # method leaves it up to the tester.
  def send_query(args)
    url = GeocodingApi::Query.new(args).url
    get url # debug here
    resp = GeocodingApi::Response.new(json_body)
    expect(resp.status).to eq 'OK'
    resp
  end

  def send_error_query(args)
    url = GeocodingApi::Query.new(args).url
    get url
    GeocodingApi::Response.new(json_body)
  end
end

RSpec::Matchers.define :be_close_to do |expected|
  match do |actual|
    expected_lat, expected_lng = expected.split(',').map(&:to_f)
    actual_lat, actual_lng = actual.split(',').map(&:to_f)
    delta = 0.0001 # this is approx. 10m for lat/lng coords
    ((expected_lat - actual_lat).abs <= delta) && ((expected_lng - actual_lng).abs <= delta)
  end
end
