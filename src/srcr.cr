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
  class StringToTimeTypeConverter
    def self.from_json(value : JSON::PullParser) : SRcr::TimeType
      case value.read_string
      when "realtime"
        SRcr::TimeType::Realtime
      when "realtime_noloads"
        SRcr::TimeType::RealtimeNoLoads
      when "ingame"
        SRcr::TimeType::Ingame
      when "primary"
        SRcr::TimeType::Primary
      end
    end
    def self.to_json(value : SRcr::TimeType, json : JSON::Builder)
      case value
      when SRcr::TimeType::Primary
        "primary".to_json(json)
      when SRcr::TimeType::Realtime
        "realtime".to_json(json)
      when SRcr::TimeType::RealtimeNoLoads
        "realtime_noloads".to_json(json)
      when SRcr::TimeType::Ingame
        "ingame".to_json(json)
      end
    end
  end
end
