module GeocodingApi
  class LatLng
    include Virtus.value_object
    attribute :lat, Float
    attribute :lng, Float
  end
  class Bound
    include Virtus.model
    attribute :northeast, GeocodingApi::LatLng
    attribute :southwest, GeocodingApi::LatLng
  end
  class Geometry
    include Virtus.model
    attribute :bounds, GeocodingApi::Bound
    attribute :location, GeocodingApi::LatLng
    attribute :location_type, String
    attribute :viewport, GeocodingApi::Bound
  end
  class AddressComponent
    include Virtus.model
    attribute :long_name, String
    attribute :short_name, String
    attribute :types, Array[String]
  end
  class Result
    include Virtus.model
    attribute :address_components, Array[GeocodingApi::AddressComponent]
    attribute :formatted_address, String
    attribute :geometry, GeocodingApi::Geometry
    attribute :place_id, String
    attribute :types, Array[String]
    attribute :partial_match, Boolean
  end
  class Response
    include Virtus.model
    attribute :status, String
    attribute :results, Array[GeocodingApi::Result]

    def location
      return nil if results.length < 1
      "#{results.first.geometry.location.lat},#{results.first.geometry.location.lng}"
    end
  end
end
