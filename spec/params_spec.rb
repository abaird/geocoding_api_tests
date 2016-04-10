require 'spec_helper'
require 'airborne'

describe 'Geocoding API input params' do
  # TODO: put a model in for all the attributes in the Query class
  # TODO: abstract out the actual place into a file that can be read in
  let(:address) { '2816 Purple Thistle Dr, Pflugerville, TX 78660, USA' }
  let(:latlng) { '30.4887798,-97.56140049999999' }
  let(:place_id) { 'ChIJxUO0ldPERIYRgMsbEVZO_tE' }
  let(:escaped_address) { CGI.escape address }

  it 'should perform a forward lookup on address' do
    resp = GeocodingApi::Query.new(address: escaped_address).get
    expect(resp.status).to eq 'OK'
    expect(resp.location).to eq latlng
    expect(resp.results.first.place_id).to eq place_id
  end

  it 'should perform a reverse lookup on latitude longitude' do
    resp = GeocodingApi::Query.new(latlng: latlng).get
    expect(resp.status).to eq 'OK'
    expect(resp.results.first.formatted_address).to eq address
    expect(resp.results.first.place_id).to eq place_id
  end

  it 'should perform a reverse lookup on place id' do
    resp = GeocodingApi::Query.new(place_id: place_id).get
    expect(resp.status).to eq 'OK'
    expect(resp.location).to eq latlng
    expect(resp.results.first.formatted_address).to eq address
  end

  it 'should not allow search on place_id with latlng or address' do
    param_list = [
        {address: escaped_address, place_id: place_id},
        {latlng: latlng, place_id: place_id}
    ]
    param_list.each do |search_props|
      url = GeocodingApi::Query.new(search_props).url
      get url
      resp = GeocodingApi::Response.new(json_body)
      expect(resp.status).to eq 'INVALID_REQUEST'
      expect(response.code).to eq 400
    end
  end

  it 'should allow a query with address and latlng' do
    url = GeocodingApi::Query.new(address: escaped_address, latlng: latlng).url
    get url
    resp = GeocodingApi::Response.new(json_body)
    expect(resp.status).to eq 'OK'
    expect(resp.results.first.place_id).to eq place_id
  end

  it 'should not allow a query with an invalid api' do
    url = GeocodingApi::Query.new(address: escaped_address, key: '123456').url
    get url
    resp = GeocodingApi::Response.new(json_body)
    expect(resp.status).to eq 'REQUEST_DENIED'
    expect(response.code).to eq 200
  end

  it 'should return the query in XML' do
    resp = GeocodingApi::Query.new(address: escaped_address).xml_get

    # NOTE: these results are just Ruby data structures since the XML and JSON
    #       don't use the same keys. A more complete implementation would have
    #       another model that correctly modeled the XML structure.
    expect(resp[:status]).to eq 'OK'
    expect(resp[:result][:place_id]).to eq place_id
    expect(resp[:result][:formatted_address]).to eq address
  end
end
