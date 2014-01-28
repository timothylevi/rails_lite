require 'uri'

class Params
  # use your initialize to merge params from
  # 1. query string
  # 2. post body
  # 3. route params
  def initialize(req, route_params = {})
    @params ||= {}
    @params.merge!(parse_www_encoded_form(route_params))
    @params.merge!(parse_www_encoded_form(req.body)) if req.body
    @params.merge!(parse_www_encoded_form(req.query_string)) if req.query_string
  end

  def [](key)
    @params[key]
  end

  def to_s
    @params.to_s
  end

  private
  def parse_www_encoded_form(www_encoded_form)
    params = {}

    URI.decode_www_form(www_encoded_form).each do |key, value|
      scope = params
      sequence = parse_key(key)

      sequence.each_with_index do |sub_key, idx|
        if (idx + 1) == sequence.count
          scope[sub_key] = value
        else
          scope[sub_key] ||= {}
          scope = scope[sub_key]
        end
      end

    end

    params
  end

  def parse_key(key)
    remainder = /(?<head>.*)\[(?<rest>.*)\]/.match(key)
    if remainder.nil?
      [key]
    else
      parse_key(remainder["head"]) + [remainder["rest"]]
    end
  end
end