require 'json'
require 'webrick'

class Session
  # find the cookie for this app
  # deserialize the cookie into a hash
  def initialize(req)
    @req = req
    @cookie = search_cookies
  end

  def search_cookies
    @req.cookies.each do |cookie|
      return JSON.parse(cookie.value) if cookie.name == "_rails_lite_app"
    end

    {}
  end

  def [](key)
    @cookie[key]
  end

  def []=(key, val)
    @cookie[key] = val
  end

  # serialize the hash into json and save in a cookie
  # add to the responses cookies
  def store_session(res)
    json = @cookie.to_json
    cookie = WEBrick::Cookie.new("_rails_lite_app", json)
    res.cookies << cookie
  end
end
