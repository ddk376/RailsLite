require 'uri'

module Phase5
  class Params
    # use your initialize to merge params from
    # 1. query string
    # 2. post body
    # 3. route params
    #
    # You haven't done routing yet; but assume route params will be
    # passed in as a hash to `Params.new` as below:

    def initialize(req, route_params = {})
      #meta_vars["PATH_INFO"].split("/").last.to_s
      query_params = parse_www_encoded_form(req.query_string) || {}
      body_params = parse_www_encoded_form(req.body) || {} #body_str[/\w+=\w+/]
      # p query_params

      @params = route_params.merge(query_params).merge(body_params)
    end

    def [](key)
      @params[key.to_s] || @params[key.to_sym]
    end

    # this will be useful if we want to `puts params` in the server log
    def to_s
      @params.to_s
    end

    class AttributeNotFoundError < ArgumentError; end;

    private
    # this should return deeply nested hash
    # argument format
    # user[address][street]=main&user[address][zip]=89436
    # should return
    # { "user" => { "address" => { "street" => "main", "zip" => "89436" } } }
    def parse_www_encoded_form(www_encoded_form)
      return {} if www_encoded_form.nil?
      result = {}
      array_of_param_pairs = URI::decode_www_form(www_encoded_form)
      array_of_param_pairs.each do |param|
        key, value = param.first, param.last
        accum_hash = result
        nested_keys = parse_key(key)
        nested_keys.each do |el|
          if el == nested_keys.last
            accum_hash[el] = value
          else
            accum_hash[el] ||= {}
            accum_hash = accum_hash[el]
          end
        end
      end
      result
    end

    # this should return an array
    # user[address][street] should return ['user', 'address', 'street']
    def parse_key(key)
      key.split(/\]\[|\[|\]/)
    end
  end
end
