require "./srcr/*"
require "http/client"

module SRcr
  USER_AGENT = "SRcr/" + SRcr::VERSION
  API_ROOT = "https://www.speedrun.com/api/v1/"
  CLIENT = HTTP::Client.new(URI.parse "https://www.speedrun.com")
  class StringToURIConverter
    def self.from_json(value : JSON::PullParser) : URI
      URI.parse(value.read_string)
    end
    def self.to_json(value : URI, json : JSON::Builder)
      value.to_s.to_json(json)
    end
  end
end
