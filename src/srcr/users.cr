require "./res"
require "./leaderboards"
require "json"

module SRcr
  class User
    JSON.mapping(
      id: {type: String, setter: false},
      names: {type: SRcr::NameSet, setter: false},
      weblink: {type: String, setter: false},
      name_style: {type: SRcr::NameStyle, key: "name-style", setter: false},
      role: {type: SRcr::UserRole, converter: SRcr::StringToUserRoleConverter, setter: false},
      signup: {type: Time, nilable: true, converter: Time::Format.new("%Y-%m-%dT%H:%M:%SZ"), setter: false},
      location: {type: SRcr::Location, nilable: true, setter: false},
      twitch: {type: SRcr::Link, nilable: true, setter: false},
      hitbox: {type: SRcr::Link, nilable: true, setter: false},
      youtube: {type: SRcr::Link, nilable: true, setter: false},
      twitter: {type: SRcr::Link, nilable: true, setter: false},
      speedrunslive: {type: SRcr::Link, nilable: true, setter: false},
      links: {type: Array(SRcr::Link), setter: false}
    )

    def self.from_id(id : String) : SRcr::User
      SRcr::User.from_json(SRcr::CLIENT.get(SRcr::API_ROOT + "users/" + id).body, "data")
    end

    def self.search(name : String) : Array(SRcr::User)
      Array(SRcr::User).from_json(SRcr::CLIENT.get(SRcr::API_ROOT + "users?lookup=" + URI.escape(name, true)).body)
    end

    def personal_bests : Array(SRcr::PlacedRun)
      Array(SRcr::PlacedRun).from_json(SRcr::CLIENT.get(SRcr::API_ROOT + "users/" + id + "/personal-bests").body, "data")
    end
  end
  enum NameStyleType
    Solid
    Gradient
  end
  class NameStyle
    JSON.mapping(
      style: {type: NameStyleType, converter: SRcr::StringToNameStyleTypeConverter, setter: false},
      color: {type: SRcr::NameColor, nilable: true, setter: false, getter: false},
      color_from: {type: SRcr::NameColor, nilable: true, key: "color-from", setter: false, getter: false},
      color_to: {type: SRcr::NameColor, nilable: true, key: "color-to", setter: false, getter: false}
    )

    def color_from : SRcr::NameColor
      case style
      when SRcr::NameStyleType::Gradient
        @color_from.not_nil!
      else
        @color.not_nil!
      end
    end

    def color_to : SRcr::NameColor
      case style
      when SRcr::NameStyleType::Gradient
        @color_to.not_nil!
      else
        @color.not_nil!
      end
    end

    def color : SRcr::NameColor
      case style
      when SRcr::NameStyleType::Solid
        @color.not_nil!
      else
        @color_from.not_nil!
      end
    end
  end
  class StringToNameStyleTypeConverter
    def self.from_json(value : JSON::PullParser) : SRcr::NameStyleType
      case value.read_string
      when "solid"
        SRcr::NameStyleType::Solid
      else
        SRcr::NameStyleType::Gradient
      end
    end
    def self.to_json(value : SRcr::NameStyleType, json : JSON::Builder)
      case value
      when SRcr::NameStyleType::Solid
        "solid".to_json(json)
      else
        "gradient".to_json(json)
      end
    end
  end
  class NameColor
    JSON.mapping(
      light: {type: Int64, converter: SRcr::NameColorToIntConverter, setter: false},
      dark: {type: Int64, converter: SRcr::NameColorToIntConverter, setter: false}
    )
  end
  class NameColorToIntConverter
    def self.from_json(value : JSON::PullParser) : Int64
      value.read_string[1..-1].to_i(16).to_i64
    end
    def self.to_json(value : Int, json : JSON::Builder)
      ("#" + value.to_s(16)).to_json(json)
    end
  end
  enum UserRole
    User
    Banned
    Trusted
    Moderator
    Admin
    Programmer
  end
  class StringToUserRoleConverter
    def self.from_json(value : JSON::PullParser) : SRcr::UserRole
      case value.read_string
      when "banned"
        SRcr::UserRole::Banned
      when "trusted"
        SRcr::UserRole::Trusted
      when "moderator"
        SRcr::UserRole::Moderator
      when "admin"
        SRcr::UserRole::Admin
      when "programmer"
        SRcr::UserRole::Programmer
      else
        SRcr::UserRole::User
      end
    end
    def self.to_json(value : SRcr::UserRole, json : JSON::Builder)
      case value
      when SRcr::UserRole::Banned
        "banned".to_json(json)
      when SRcr::UserRole::Trusted
        "trusted".to_json(json)
      when SRcr::UserRole::Moderator
        "moderator".to_json(json)
      when SRcr::UserRole::Admin
        "admin".to_json(json)
      when SRcr::UserRole::Programmer
        "programmer".to_json(json)
      else
        "user".to_json(json)
      end
    end
  end
end
