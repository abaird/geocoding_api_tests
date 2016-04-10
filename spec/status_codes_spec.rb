require 'spec_helper'

describe 'Geocoding API' do
  let(:address) { '2816 Purple Thistle Dr, Pflugerville, TX 78660, USA' }
  let(:nonsense_address) { 'asdfasdfasdfasf' }
  let(:latlng) { '30.4887798,-97.56140049999999' }
  let(:place_id) { 'ChIJxUO0ldPERIYRgMsbEVZO_tE' }
  let(:api_key) { ENV['API_KEY'] }
  let(:texas_bounds) { 'bounds=25.8371638,-106.6456461|36.5007041,-93.5080389' }
  let(:new_york_bounds) { 'bounds=40.4960439,-74.2557349|40.9152556,-73.7002721' }
  let(:ny_postal_code_component) { 'postal_code:12345|administrative_area:NY' }
  let(:tx_postal_code_component) { 'postal_code:78660|administrative_area:TX' }

  context 'status codes' do
    it 'should return a ZERO_RESULTS status code when there are no results' do
      url = GeocodingApi::Query.new(address: nonsense_address).url
      get url
      resp = GeocodingApi::Response.new(json_body)
      expect(resp.status).to eq 'ZERO_RESULTS'
      expect(response.code).to eq 200
    end

    it 'should return REQUEST_DENIED status code when using an invalid key' do
      url = GeocodingApi::Query.new(address: address, key: '123456').url
      get url
      resp = GeocodingApi::Response.new(json_body)
      expect(resp.status).to eq 'REQUEST_DENIED'
      expect(response.code).to eq 200
    end

    it 'should return INVALID_REQUEST when the query is improperly formatted' do
      url = "https://maps.googleapis.com/maps/api/geocode/json?foo=bar&key=#{api_key}"
      get url
      resp = GeocodingApi::Response.new(json_body)
      expect(resp.status).to eq 'INVALID_REQUEST'
      expect(response.code).to eq 400
    end

    it 'should return INVALID_REQUEST if there are extra parameters in the request' do
      pending 'extra parameters are allowed in a query'
      url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{address}&foo=bar&key=#{api_key}"
      get url
      resp = GeocodingApi::Response.new(json_body)
      expect(resp.status).to eq 'INVALID_REQUEST'
      expect(response.code).to eq 400
    end

    it 'should return INVALID_REQUEST if an invalid result_type is given' do
      url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=#{latlng}&result_type=foo|bar&key=#{api_key}"
      get url
      resp = GeocodingApi::Response.new(json_body)
      expect(resp.status).to eq 'INVALID_REQUEST'
      expect(response.code).to eq 400
    end

    it 'should return INVALID_REQUEST if an invalid location_type is given' do
      url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=#{latlng}&location_type=foo&key=#{api_key}"
      get url
      resp = GeocodingApi::Response.new(json_body)
      expect(resp.status).to eq 'INVALID_REQUEST'
      expect(response.code).to eq 400
    end

    it 'should return INVALID_REQUEST if reverse lookup types are used in a forward lookup query' do
      pending 'reverse lookup types are allowed in a forward lookup query'
      ['location_type=ROOFTOP', 'result_type=country'].each do |restricted_type|
        url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{address}&#{restricted_type}&key=#{api_key}"
        get url
        resp = GeocodingApi::Response.new(json_body)
        expect(resp.status).to eq 'INVALID_REQUEST'
        expect(response.code).to eq 400
      end
    end

    it 'should return INVALID_REQUEST if forward lookup types are used in a reverse lookup query' do
      pending 'forward lookup types are allowed in a reverse lookup query'
      [texas_bounds, new_york_bounds, ny_postal_code_component, tx_postal_code_component].each do |restricted_type|
        url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=#{latlng}&#{restricted_type}&key=#{api_key}"
        get url
        resp = GeocodingApi::Response.new(json_body)
        expect(resp.status).to eq 'INVALID_REQUEST'
        expect(response.code).to eq 400
      end
    end
  end
end