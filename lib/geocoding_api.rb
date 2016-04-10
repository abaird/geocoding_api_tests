require 'rest-client'
require 'virtus'
require 'geocoding_api/response'

module GeocodingApi
  class Query
    def initialize(address: nil, latlng: nil, place_id: nil, key: nil)
      @address = address
      @latlng = latlng
      @place_id = place_id
      @query_args = {address: @address, latlng: @latlng, place_id: @place_id}
      find_api_key(key)
    end

    def find_api_key(key)
      @api_key = key || ENV['API_KEY']
    end

    def url
      query_parameters = ''
      @query_args.delete_if { |_k, v| v.nil? }.each_pair do |k, v|
        query_parameters += "#{k}=#{v}&"
      end
      "#{geocode_resource_url}/json?#{query_parameters}key=#{@api_key}"
    end

    def geocode_resource_url
      'https://maps.googleapis.com/maps/api/geocode'
    end

    def get
      response = RestClient.get(url)
      json = JSON.parse(response.body)
      GeocodingApi::Response.new(json)
    end
  end
end
