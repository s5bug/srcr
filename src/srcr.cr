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
      else
        SRcr::TimeType::Primary
      end
    end
    def self.to_json(value : SRcr::TimeType, json : JSON::Builder)
      case value
      when SRcr::TimeType::Realtime
        "realtime".to_json(json)
      when SRcr::TimeType::RealtimeNoLoads
        "realtime_noloads".to_json(json)
      when SRcr::TimeType::Ingame
        "ingame".to_json(json)
      else
        "primary".to_json(json)
      end
    end
  end
  class StringArrayToTimeTypeArrayConverter
    def self.from_json(value : JSON::PullParser) : Array(SRcr::TimeType)
      values = [] of SRcr::TimeType
      value.read_array do
        values << StringToTimeTypeConverter.from_json(value)
      end
      values
    end
  end
  def self.average_colors(ca : Array(Int64)) : Int64
    ar = 0
    ag = 0
    ab = 0
    ca.each do |c|
      ab += c & 0xff
      ag += (c >> 8) & 0xff
      ar += (c >> 16) & 0xff
    end
    (ab / ca.length) + ((ag / ca.length) << 8) + ((ar / ca.length) << 16)
  end
end
