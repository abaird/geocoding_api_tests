module GeocodingApi
  # Responsible for building the query to Google. The 3 main parameters are named, any optional
  # params can be added as symbol:value pairs. Ex:
  #
  #    Query.new(address: 'my address',
  #              latlng: '12.345,67.890',
  #              foo: 'bar',
  #              result_type: 'one|two')
  #

  class Query
    def initialize(address: nil, latlng: nil, place_id: nil, key: nil, **optional_params)
      @address = address
      @latlng = latlng
      @place_id = place_id
      @optional_params = optional_params
      @query_args = { address: @address, latlng: @latlng, place_id: @place_id }
      find_api_key(key)
    end

    def url
      "#{geocode_resource_url}/json?" +
        build_param_string(@query_args).to_s +
        build_param_string(@optional_params).to_s +
        "key=#{@api_key}"
    end

    def geocode_resource_url
      'https://maps.googleapis.com/maps/api/geocode'
    end

    def xml_get
      # NOTE: the keys are different between XML and JSON
      # in order to do this like get, you would need a different model - not enough time for that
      xml_response = RestClient.get(url.gsub('json', 'xml'))
      parser = Nori.new(parser: :rexml, convert_tags_to: ->(tag) { tag.snakecase.to_sym })
      parser.parse(xml_response.body)[:geocode_response]
    end

    private

    def find_api_key(key)
      @api_key = key || ENV['API_KEY']
    end

    def build_param_string(params)
      string = ''
      params.delete_if { |_k, v| v.nil? }.each_pair do |k, v|
        string += "#{k}=#{v}&"
      end
      string
    end
  end
end
