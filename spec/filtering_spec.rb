require 'spec_helper'

describe 'Geocoding API' do
  let(:texas_bounds) { '25.8371638,-106.6456461|36.5007041,-93.5080389' }
  let(:texas_bounds_rev) { '36.5007041,-93.5080389|25.8371638,-106.6456461' }
  let(:new_york_bounds) { '40.496091,-79.76214379999999|45.015865,-71.85620639999999' }

  context 'bounding box' do
    it 'should limit results to a particular region' do
      pending 'still finds 6 results all over the US and France'
      resp = send_query(address: 'Paris', bounds: texas_bounds)
      expect(resp.result_count).to eq 1
    end

    it 'should find the state TX when supplied a Texas-sized bounding box' do
      resp = send_query(bounds: texas_bounds)
      expect(resp.result_count).to eq 1
      expect(resp.results.first.formatted_address).to eq 'Texas, USA'
    end

    it 'should find the state NY when supplied a NY-sized bounding box' do
      resp = send_query(bounds: new_york_bounds)
      expect(resp.result_count).to eq 1
      expect(resp.results.first.formatted_address).to eq 'New York, USA'
    end

    it 'should find ZERO_RESULTS when the bounding box corners are reversed' do
      resp = send_error_query(bounds: texas_bounds_rev)
      expect(resp.status).to eq 'ZERO_RESULTS'
      expect(response.code).to eq 200
    end
  end

  context 'component' do
    it 'should find Paris, FR only' do
      pending 'filtering by country:fr should find only one Paris'
      resp = send_query(address: 'paris', component: 'country:fr')
      expect(resp.result_count).to eq 1
    end

    it 'should return INVALID_REQUEST when only sending a component filter' do
      resp = send_error_query(component: 'administrative_area:tx')
      expect(resp.status).to eq 'INVALID_REQUEST'
      expect(response.code).to eq 400
    end
  end

  context 'region' do
    it 'should find Paris, FR only' do
      resp = send_query(address: 'paris', region: 'fr')
      expect(resp.result_count).to eq 1
    end
  end
end
