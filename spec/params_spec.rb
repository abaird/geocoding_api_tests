require 'spec_helper'

describe 'Geocoding API input params' do
  let(:address) { '1600+Amphitheatre+Parkway,+Mountain+View,+CA' }
  let(:latlng) { '37.4224497,-122.0840329' }
  let(:place_id) { 'ChIJ2eUgeAK6j4ARbn5u_wAGqWA' }
  let(:bldg_40_place_id) { 'ChIJj38IfwK6j4ARNcyPDnEGa9g' }
  let(:bldg_40_address) { 'Google Bldg 40, 1600 Amphitheatre Pkwy, Mountain View, CA 94043, USA' }

  it 'should perform a forward lookup on address' do
    url = GeocodingApi::Query.new(address: address).url
    get url
    resp = GeocodingApi::Response.new(json_body)
    expect(resp.status).to eq 'OK'
    expect(resp.location).to eq '37.4224497,-122.0840329'
    expect(resp.results.first.place_id).to eq place_id
  end

  it 'should perform a reverse lookup on latitude longitude' do
    url = GeocodingApi::Query.new(latlng: latlng).url
    get url
    resp = GeocodingApi::Response.new(json_body)
    expect(resp.status).to eq 'OK'
    expect(resp.results.first.formatted_address).to eq bldg_40_address
    expect(resp.results.first.place_id).to eq bldg_40_place_id
  end

  it 'should perform a reverse lookup on place id' do
    url = GeocodingApi::Query.new(place_id: place_id).url
    get url
    resp = GeocodingApi::Response.new(json_body)
    expect(resp.status).to eq 'OK'
    expect(resp.location).to eq latlng
    expect(resp.results.first.formatted_address).to eq bldg_40_address.gsub('Google Bldg 40, ', '')
  end
end
