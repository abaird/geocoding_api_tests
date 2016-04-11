# Mainly tests the object model that is behind the response. This object model gives
# a tester object oriented access to the entire JSON response.

describe 'sample geocode response' do
  let(:address) { '1600 Amphitheatre Parkway, Mountain View, CA' }
  let(:latlng) { '37.4224497,-122.0840329' }

  context 'forward lookup' do
    it 'should get google\'s latitude and longitude' do
      resp = send_query(address: address)
      expect(resp.location).to eq latlng
      expect(resp.results.first.place_id).to eq 'ChIJ2eUgeAK6j4ARbn5u_wAGqWA'
    end
  end

  context 'reverse lookup' do
    it 'should get google\s address' do
      resp = send_query(latlng: latlng)
      expected_address = 'Google Bldg 40, 1600 Amphitheatre Pkwy, Mountain View, CA 94043, USA'
      expect(resp.results.first.formatted_address).to eq expected_address
      # not sure why this is different from above
      expect(resp.results.first.place_id).to eq 'ChIJj38IfwK6j4ARNcyPDnEGa9g'
    end
  end

  let(:geocode_response) do
    send_query(address: address)
  end

  # I wrote the tests below initially using VCR to record the responses for fast playback.
  # This wasn't technically necessary, but since I was coding a very specific object,
  # I wanted to make sure it was always available the way I initially tested it. If you
  # want to test against a live repsonse, either remove the files under 'fixtures/vcr_cassettes'
  # or remove the :vcr tag on the context below.

  context 'response object parsing', :vcr do
    it 'should parse top level attributes for the geocode response' do
      expect(geocode_response.results).to be_kind_of(Array)
      expect(geocode_response.results.first.place_id).to eq 'ChIJ2eUgeAK6j4ARbn5u_wAGqWA'
    end

    it 'should parse 2nd level results attributes for the geocode response' do
      subject = geocode_response.results.first
      expect(subject.address_components).to all(be_a(GeocodingApi::AddressComponent))
      expect(subject.address_components.length).to eq 7
      expect(subject.formatted_address).to eq '1600 Amphitheatre Pkwy, Mountain View, CA 94043, USA'
      expect(subject.geometry).to be_a GeocodingApi::Geometry
      expect(subject.place_id).to eq 'ChIJ2eUgeAK6j4ARbn5u_wAGqWA'
      expect(subject.types).to all(be_a(String))
      expect(subject.types.first).to eq 'street_address'
      expect(subject.partial_match).to be nil
    end

    it 'should parse 3rd level address component attributes for the geocode response' do
      subject = geocode_response.results.first.address_components.first
      expect(subject.long_name).to eq '1600'
      expect(subject.short_name).to eq '1600'
      expect(subject.types.first).to eq 'street_number'
    end

    it 'should parse 3rd level geometry attributes for the geocode response' do
      subject = geocode_response.results.first.geometry
      expect(subject.bounds).to be nil
      expect(subject.location).to be_a(GeocodingApi::LatLng)
      expect(subject.location_type).to eq 'ROOFTOP'
      expect(subject.viewport).to be_a(GeocodingApi::Bound)
    end

    it 'should parse 4th level bound attributes for the geocode response' do
      subject = geocode_response.results.first.geometry.viewport
      expect(subject.northeast).to be_a(GeocodingApi::LatLng)
      expect(subject.southwest).to be_a(GeocodingApi::LatLng)
    end

    it 'should parse 5th level Lat - Lng attributes for the geocode response' do
      subject = geocode_response.results.first.geometry
      expect(subject.location.lat).to eq(37.4224497)
      expect(subject.location.lng).to eq(-122.0840329)
      expect(subject.viewport.northeast.lat).to eq(37.4237986802915)
      expect(subject.viewport.southwest.lng).to eq(-122.0853818802915)
    end
  end
end
