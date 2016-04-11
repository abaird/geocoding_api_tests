require 'spec_helper'

describe 'Geocoding API' do
  let(:statue_of_liberty) { '40.6892490,-74.0445000' }
  let(:statue_of_liberty_addr) { 'Liberty Island, New York, NJ, USA' }
  let(:statue_of_liberty_box) { '40.6884436,-74.0477723|40.6914699,-74.0423220' }
  let(:liberty_island_addr) { 'Liberty Island, New York, NJ, USA' }
  let(:the_alamo_latlng) { '29.4260137,-98.4861474' }
  let(:the_alamo_addr) { 'The Alamo, 300 Alamo Plaza, San Antonio, TX 78205, USA' }

  it 'should find the Statue of Liberty' do
    resp = send_query(latlng: statue_of_liberty, result_type: 'neighborhood')
    expect(resp.formatted_addresses.first).to eq statue_of_liberty_addr
  end

  it 'should find Liberty Island' do
    resp = send_query(bounds: statue_of_liberty_box)
    expect(resp.results.first.formatted_address).to eq liberty_island_addr
  end

  it 'should find the Alamo by address' do
    resp = send_query(address: the_alamo_addr)
    expect(resp.location).to be_close_to the_alamo_latlng
  end

  it 'should find the Alamo by location' do
    resp = send_query(latlng: the_alamo_latlng, result_type: 'premise')
    expect(resp.formatted_addresses.first).to match 'The Alamo'
  end
end
