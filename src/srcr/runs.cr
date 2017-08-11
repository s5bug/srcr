require "../srcr"
require "./res"
require "json"

module SRcr
  class Run
    JSON.mapping(
      id: {type: String, setter: false},
      weblink: {type: URI, converter: SRcr::StringToURIConverter, setter: false},
      game: {type: String, getter: false, setter: false}, # TODO Getter
      level: {type: String, nilable: true, getter: false, setter: false}, # TODO Getter
      category: {type: String, setter: false},
      videos: {type: SRcr::VideoListing, setter: false},
      status: {type: SRcr::RunStatus, setter: false},
      players: {type: Array(SRcr::Player), setter: false},
      date: {type: Time, nilable: true, converter: Time::Format.new("%Y-%m-%d"), setter: false},
      submitted: {type: Time, nilable: true, converter: Time::Format.new("%Y-%m-%d"), setter: false},
      times: {type: SRcr::TimeSet, setter: false},
      system: {type: SRcr::System, setter: false},
      splits: {type: SRcr::Resource, nilable: true, setter: false},
      values: {type: Hash(String, String), getter: false, setter: false}, # TODO Getter
      links: {type: Array(SRcr::Resource), setter: false}
    )

    def self.from_id(id : String) : Run
      SRcr::Run.from_json(SRcr::CLIENT.get(SRcr::API_ROOT + "runs/" + id).body, "data")
    end
  end
  class VideoListing
    JSON.mapping(
      text: {type: String, nilable: true, setter: false},
      links: {type: Array(SRcr::Link), setter: false}
    )
  end
  class RunStatus
    JSON.mapping(
      status: String,
      examiner: String,
      verify_date: {type: String, key: "verify-date"}
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
      primary: {type: Time::Span, converter: SRcr::TimeSetStringConverter, setter: false},
      primary_t: {type: Float64, setter: false},
      realtime: {type: Time::Span, nilable: true, converter: SRcr::TimeSetStringConverter, setter: false},
      realtime_t: {type: Float64, nilable: true, setter: false},
      realtime_noloads: {type: Time::Span, nilable: true, converter: SRcr::TimeSetStringConverter, setter: false},
      realtime_noloads_t: {type: Float64, nilable: true, setter: false},
      ingame: {type: Time::Span, nilable: true, converter: SRcr::TimeSetStringConverter, setter: false},
      ingame_t: {type: Float64, nilable: true, setter: false}
    )
  end
  class TimeSetStringConverter

    TIME_REGEX = /PT(?:(?<h>\d+)H)?(?:(?<m>\d+)M)?(?<s>\d+(?:\.\d+)?)S/

    def self.from_json(value : JSON::PullParser) : Time::Span
      d = TIME_REGEX.match(value.read_string)
      t = 0.days
      if(!d.nil?)
        if(!d["h"]?.nil?)
          t += d["h"].to_i.hours
        end
        if(!d["m"]?.nil?)
          t += d["m"].to_i.minutes
        end
        if(!d["s"]?.nil?)
          t += d["s"].to_f.seconds
        end
      end
      t
    end
    def self.to_json(value : Time, json : JSON::Builder)
      "null" # TODO Implement a thing
    end
  end
end
