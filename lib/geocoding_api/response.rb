module GeocodingApi
  # Model for the geocode response. Allows access to all points of
  # the response along with convenience methods for getting at buried
  # data.
  #
  # ex:
  #   obj = GeocodingApi::Response.new(object)
  #    -> where object is a symbolized hash representing the response
  #   obj.status                          -> gets API status
  #   obj.results.first                   -> returns first result (if there is one)
  #   obj.results.first.formatted_address -> gets fancy address of first result

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

    def address_component_by_type(type)
      address_components.select { |comp| comp.types.include?(type) }
    end

    def address_component_count
      address_components.count
    end
  end
  class Response
    include Virtus.model
    attribute :status, String
    attribute :results, Array[GeocodingApi::Result]

    def location
      return nil if results.empty?
      "#{results.first.geometry.location.lat},#{results.first.geometry.location.lng}"
    end

    def result_count
      results.length
    end

    def formatted_addresses
      return [] if results.empty?
      results.map(&:formatted_address)
    end
  end
end
