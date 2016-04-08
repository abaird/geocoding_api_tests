require 'spec_helper'

describe GeocodingApiTests do
  let(:api_key) { ENV['API_KEY'] }
  let(:geocode_resource_url) { 'https://maps.googleapis.com/maps/api/geocode' }

  it 'gets google\'s geolocation' do
    address = '1600+Amphitheatre+Parkway,+Mountain+View,+CA'
    get "#{geocode_resource_url}/json?address=#{address}&key=#{api_key}"
    expect(json_body[:status]).to eq 'OK'
  end
end
