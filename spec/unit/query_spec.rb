require 'spec_helper'

describe 'sample geocode response' do
  let(:address) { 'sample address' }
  let(:latlng) { '12.345,-67.890' }
  let(:place_id) { 'ABCDEFG' }
  let(:base_url) { GeocodingApi::Query.new.geocode_resource_url + '/json?' }
  let(:key_string) { 'key=' + ENV['API_KEY'] }

  context 'Query builder' do
    it 'should format an address URL' do
      url = GeocodingApi::Query.new(address: address).url
      expect(url).to eq(base_url + "address=#{address}&" + key_string)
    end

    it 'should format a latlng URL' do
      url = GeocodingApi::Query.new(latlng: latlng).url
      expect(url).to eq(base_url + "latlng=#{latlng}&" + key_string)
    end

    it 'should format a place_id URL' do
      url = GeocodingApi::Query.new(place_id: place_id).url
      expect(url).to eq(base_url + "place_id=#{place_id}&" + key_string)
    end

    it 'should format a query with all three main search params' do
      url = GeocodingApi::Query.new(place_id: place_id,
                                    address: address,
                                    latlng: latlng).url
      params = "address=#{address}&" + "latlng=#{latlng}&" + "place_id=#{place_id}&"
      expect(url).to eq(base_url + params + key_string)
    end

    it 'should add in an optional param' do
      url = GeocodingApi::Query.new(latlng: latlng,
                                    foo: 'bar').url
      expect(url).to eq(base_url + "latlng=#{latlng}&" + 'foo=bar&' + key_string)
    end

    it 'should handle multiple params' do
      url = GeocodingApi::Query.new(address: address,
                                    latlng: latlng,
                                    foo: 'bar',
                                    result_type: 'one|two').url
      params = "address=#{address}&" + "latlng=#{latlng}&"
      options = 'foo=bar&result_type=one|two&'
      expect(url).to eq(base_url + params + options + key_string)
    end
  end
end
