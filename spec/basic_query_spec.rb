describe 'Geocoding API input params' do
  # NOTE - this can be any location as long as the address, latlng
  # and place_id refer to the same thing. The example given in the Google
  # help doc, Google HQ, doesn't work this way.
  let(:address) { '2816 Purple Thistle Dr, Pflugerville, TX 78660, USA' }
  let(:latlng) { '30.4887798,-97.56140049999999' }
  let(:place_id) { 'ChIJxUO0ldPERIYRgMsbEVZO_tE' }

  it 'should perform a forward lookup on address' do
    resp = send_query(address: address)
    expect(resp.location).to eq latlng
    expect(resp.results.first.place_id).to eq place_id
  end

  it 'should perform a reverse lookup on latitude longitude' do
    resp = send_query(latlng: latlng)
    expect(resp.results.first.formatted_address).to eq address
    expect(resp.results.first.place_id).to eq place_id
  end

  it 'should perform a reverse lookup on place id' do
    resp = send_query(place_id: place_id)
    expect(resp.location).to eq latlng
    expect(resp.results.first.formatted_address).to eq address
  end

  it 'should allow a query with address and latlng' do
    resp = send_query(address: address, latlng: latlng)
    expect(resp.status).to eq 'OK'
    expect(resp.results.first.place_id).to eq place_id
  end

  it 'should not allow search on place_id with latlng or address' do
    param_list = [
        {address: address, place_id: place_id},
        {latlng: latlng, place_id: place_id}
    ]
    param_list.each do |search_props|
      resp = send_error_query(search_props)
      expect(resp.status).to eq 'INVALID_REQUEST'
      expect(response.code).to eq 400
    end
  end

  it 'should return the query in XML' do
    resp = GeocodingApi::Query.new(address: address).xml_get

    # NOTE: these results are just Ruby data structures since the XML and JSON
    #       don't use the same keys. A more complete implementation would have
    #       another model that correctly modeled the XML structure.
    expect(resp[:status]).to eq 'OK'
    expect(resp[:result][:place_id]).to eq place_id
    expect(resp[:result][:formatted_address]).to eq address
  end
end
