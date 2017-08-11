require "../srcr"
require "./res"
require "json"

module SRcr
  class Run
    JSON.mapping(
      id: {type: String, setter: false},
      weblink: {type: URI, converter: SRcr::StringToURIConverter, setter: false},
      game: {type: String, getter: false, setter: false},
      level: {type: String, nilable: true, getter: false, setter: false},
      category: {type: String, setter: false},
      videos: {type: SRcr::VideoListing, setter: false},
      status: {type: SRcr::RunStatus, setter: false},
      players: {type: Array(SRcr::Player), setter: false},
      date: {type: Time, nilable: true, converter: Time::Format.new("%Y-%m-%d"), setter: false},
      submitted: {type: Time, nilable: true, converter: Time::Format.new("%Y-%m-%d"), setter: false},
      times: {type: SRcr::TimeSet, setter: false}
    )
  end
  class VideoListing
    JSON.mapping(
      text: {type: String, setter: false},
      links: {type: Array(SRcr::Link), setter: false}
    )
  end
  class Player
    JSON.mapping(
      rel: {type: SRcr::PlayerType, setter: false},
      name: {type: String, nilable: true, setter: false},
      id: {type: String, nilable: true, setter: false},
      uri: {type: URI, converter: SRcr::StringToURIConverter, setter: false}
    )
  end
  enum PlayerType
    User
    Guest
  end
  class TimeSet
    JSON.mapping(
      primary: {type: Time, converter: SRcr::TimeSetStringConverter, setter: false}
    )
  end
  class TimeSetStringConverter

    TIME_REGEX = /PT(?:(?<h>\d+)H)?(?:(?<m>\d+)M)?(?<s>\d+(?:\.\d+)?)S/

    def self.from_json(value : JSON::PullParser) : Time
      d = TIME_REGEX.match(value.read_string)
      t = 0.days
      if(!d["h"]?.is_nil?)
        t += d["h"].to_i.hours
      end
      if(!d["m"]?.is_nil?)
        t += d["m"].to_i.minutes
      end
      if(!d["s"]?.is_nil?)
        t += d["s"].to_f.seconds
      end
      t
    end
    def self.to_json(value : Time, json : JSON::Builder)
      "null" # TODO Implement a thing
    end
  end
end
