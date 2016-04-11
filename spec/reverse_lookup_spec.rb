require 'spec_helper'

def invalid_coords
  ['190,190', '-100,0', '100,0', '0,190', '0,-190', '-0,-0', 'foo,bar', '30.0.0,30.0.0']
end

describe 'Geocoding API' do
  let(:address) { '2816 Purple Thistle Dr, Pflugerville, TX 78660, USA' }
  let(:street_address) { 'Penny Royal Dr, Pflugerville, TX 78660, USA' }
  let(:latlng) { '30.4887798,-97.56140049999999' }
  let(:place_id) { 'ChIJxUO0ldPERIYRgMsbEVZO_tE' }
  let(:texas_bounds) { 'bounds=25.8371638,-106.6456461|36.5007041,-93.5080389' }
  let(:new_york_bounds) { 'bounds=40.4960439,-74.2557349|40.9152556,-73.7002721' }
  let(:ny_postal_code_component) { 'postal_code:12344|administrative_area:NY' }
  let(:tx_postal_code_component) { 'postal_code:78660|administrative_area:TX' }

  context 'reverse_lookup' do
    invalid_coords.each do |coord|
      it "should throw an error using lat lng coordinates: #{coord}" do
        resp = send_error_query(latlng: coord)
        expect(resp.status).to eq 'ZERO_RESULTS'
        expect_status 200
      end
    end

    it 'should return multiple results when using lat lng' do
      resp = send_query(latlng: latlng)
      expect(resp.result_count).to eq 6
      expect(resp.formatted_addresses).to include('United States')
      expect(resp.formatted_addresses).to include(address)
    end

    it 'should return one result when using a place_id' do
      resp = send_query(place_id: place_id)
      expect(resp.result_count).to eq 1
    end

    it 'should encode results in spanish' do
      # seems to only translate countries
      resp = send_query(address: address, language: 'es')
      expect(resp.results.first.formatted_address).to match(/EE\. UU\.$/)
      expect(first_country_addr_component(resp).long_name).to eq 'Estados Unidos'
    end

    context 'result type filtering' do
      it 'should only return one result when filtering by administrative_area_level_1' do
        state_filter = 'administrative_area_level_1'
        resp = send_query(latlng: latlng, result_type: state_filter)
        expect(resp.result_count).to eq 1
        expect(resp.results.first.formatted_address).to eq 'Texas, USA'
        expect(resp.results.first.types).to include('administrative_area_level_1')
      end
      it 'should only return state and zip when filtering by multiple top level result_types' do
        filter = 'administrative_area_level_1|postal_code'
        resp = send_query(latlng: latlng, result_type: filter)
        expect(resp.result_count).to eq 2
        expect(resp.formatted_addresses).to include('Pflugerville, TX 78660, USA')
        expect(resp.formatted_addresses).to include('Texas, USA')
      end
    end

    context 'location type filtering' do
      it 'should get the lowest level address when filtering by ROOFTOP' do
        resp = send_query(latlng: latlng, location_type: 'ROOFTOP')
        expect(resp.result_count).to eq 1
        expect(resp.formatted_addresses).to include(address)
      end

      it 'should return street object when filtering by GEOMETRIC_CENTER' do
        resp = send_query(latlng: latlng, location_type: 'GEOMETRIC_CENTER')
        expect(resp.result_count).to eq 1
        expect(resp.formatted_addresses).to include(street_address)
      end

      it 'should return multiple results when filtering by ROOFTOP and APPROXIMATE' do
        filter = 'ROOFTOP|APPROXIMATE'
        resp = send_query(latlng: latlng, location_type: filter)
        expect(resp.result_count).to eq 6
        expect(resp.formatted_addresses).to include(address)
        expect(resp.formatted_addresses).to include('Texas, USA')
      end
    end
  end
end

def first_country_addr_component(resp)
  resp.results.first.address_component_by_type('country').first
end
