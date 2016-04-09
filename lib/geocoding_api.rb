require 'airborne'
require 'virtus'
require 'geocoding_api/response'

module GeocodingApi
  class Query
    def initialize(address: nil, latlng: nil, place_id: nil, key: nil)
      @address = address
      @latlng = latlng
      @place_id = place_id
      @query_args = {address: @address, latlng: @latlng, place_id: @place_id}
      qualify_args
      find_api_key(key)
    end

    def qualify_args
      msg = 'must supply either an :address, a :latlng or a :place_id'
      raise msg if (@query_args.values.all? { |x| x.nil? } || @query_args.values.reject { |x| x.nil? }.count > 1)
    end

    def find_api_key(key)
      @api_key = key || ENV['API_KEY']
    end

    def url
      lookup_value = @query_args.delete_if { |k, v| v.nil? }.flatten
      return "#{geocode_resource_url}/json?#{lookup_value[0]}=#{lookup_value[1]}&key=#{@api_key}"
    end

    def geocode_resource_url
      'https://maps.googleapis.com/maps/api/geocode'
    end
  end
end
