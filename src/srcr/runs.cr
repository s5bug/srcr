require "../srcr"
require "./res"
require "./games"
require "./users"
require "json"

module SRcr
  class Run
    JSON.mapping(
      id: {type: String, setter: false},
      weblink: {type: URI, converter: SRcr::StringToURIConverter, setter: false},
      game: {type: String, setter: false, getter: false},
      level: {type: String, nilable: true, setter: false, getter: false},
      category: {type: String, setter: false, getter: false},
      videos: {type: SRcr::VideoListing, setter: false},
      status: {type: SRcr::RunStatus, setter: false},
      players: {type: Array(SRcr::Player), setter: false},
      date: {type: Time, nilable: true, converter: Time::Format.new("%Y-%m-%d"), setter: false},
      submitted: {type: Time, nilable: true, converter: Time::Format.new("%Y-%m-%d"), setter: false},
      times: {type: SRcr::TimeSet, setter: false},
      system: {type: SRcr::System, setter: false},
      splits: {type: SRcr::Resource, nilable: true, setter: false},
      values: {type: Hash(String, String), setter: false, getter: false}, # TODO Getter
      links: {type: Array(SRcr::Resource), setter: false}
    )

    def self.from_id(id : String) : Run
      SRcr::Run.from_json(SRcr::CLIENT.get(SRcr::API_ROOT + "runs/" + id).body, "data")
    end

    def game : SRcr::Game
      SRcr::Game.from_id(@game)
    end

    def category : SRcr::Category
      SRcr::Category.from_id(@category)
    end

    def level : SRcr::Level
      SRcr::Level.from_id(@level)
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
      status: {type: String, setter: false},
      examiner: {type: String, nilable: true, getter: false, setter: false},
      verify_date: {type: Time, nilable: true, key: "verify-date", converter: Time::Format.new("%Y-%m-%dT%H:%M:%SZ"), setter: false}
    )

    def examiner : SRcr::User?
      if e = @examiner
        SRcr::User.from_id(e)
      else
        nil
      end
    end
  end
  class Player
    JSON.mapping(
      rel: {type: SRcr::PlayerType, setter: false},
      name: {type: String, nilable: true, setter: false},
      id: {type: String, nilable: true, setter: false},
      uri: {type: URI, converter: SRcr::StringToURIConverter, setter: false}
    )
    def color : Int64
      if id = @id
        user = SRcr::User.from_id(id)
        SRcr.average_colors([user.name_style.color_from.light, user.name_style.color_from.dark, user.name_style.color_to.light, user.name_style.color_from.dark])
      else
        0xffffff_i64
      end
    end
    def display_name : String
      if id = @id
        SRcr::User.from_id(id).names.international
      elsif name = @name
        name
      else
        "Unnamed"
      end
    end
  end
  enum PlayerType
    User
    Guest
  end
  class TimeSet
    JSON.mapping(
      primary: {type: Time::Span, converter: SRcr::TimeSetStringConverter, setter: false, getter: false},
      primary_t: {type: Float64, setter: false, getter: false},
      realtime: {type: Time::Span, nilable: true, converter: SRcr::TimeSetStringConverter, setter: false, getter: false},
      realtime_t: {type: Float64, nilable: true, setter: false, getter: false},
      realtime_noloads: {type: Time::Span, nilable: true, converter: SRcr::TimeSetStringConverter, setter: false, getter: false},
      realtime_noloads_t: {type: Float64, nilable: true, setter: false, getter: false},
      ingame: {type: Time::Span, nilable: true, converter: SRcr::TimeSetStringConverter, setter: false, getter: false},
      ingame_t: {type: Float64, nilable: true, setter: false, getter: false}
    )
    def [](timetype : SRcr::TimeType) : (Time::Span | Nil)
      case timetype
      when SRcr::TimeType::Realtime
        @realtime
      when SRcr::TimeType::RealtimeNoLoads
        @realtime_noloads
      when SRcr::TimeType::Ingame
        @ingame
      else
        @primary
      end
    end
    def seconds(timetype : SRcr::TimeType) : (Float64 | Nil)
      case timetype
      when SRcr::TimeType::Realtime
        @realtime_t
      when SRcr::TimeType::RealtimeNoLoads
        @realtime_noloads_t
      when SRcr::TimeType::Ingame
        @ingame_t
      else
        @primary_t
      end
    end
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
    def self.to_json(value : Time::Span, json : JSON::Builder)
      "PT" + value.hours + "H" + value.minutes + "M" + value.seconds + "." + value.milliseconds + "S"
    end
  end
end
