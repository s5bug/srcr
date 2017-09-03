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
      twitch: {type: URI, nilable: true, converter: SRcr::StringToURIConverter, setter: false},
      hitbox: {type: URI, nilable: true, converter: SRcr::StringToURIConverter, setter: false},
      youtube: {type: URI, nilable: true, converter: SRcr::StringToURIConverter, setter: false},
      twitter: {type: URI, nilable: true, converter: SRcr::StringToURIConverter, setter: false},
      speedrunslive: {type: URI, nilable: true, converter: SRcr::StringToURIConverter, setter: false},
      links: {type: Array(SRcr::Link), setter: false}
    )

    def self.from_id(id : String) : SRcr::User
      SRcr::User.from_json(SRcr::CLIENT.get(SRcr::API_ROOT + "users/" + id).body, "data")
    end

    def self.search(name : String) : Array(SRcr::User)
      Array(SRcr::User).from_json(SRcr::CLIENT.get(SRcr::API_ROOT + "users?lookup=" + URI.escape(name, true)))
    end

    def personal_bests : Array(SRcr::PlacedRun)
      Array(SRcr::PlacedRun).from_json(SRcr::CLIENT.get(SRcr::API_ROOT + "users/" + id + "/personal-bests").body, "data")
    end
  end
  class NameStyle
    JSON.mapping(
      color_from: {type: SRcr::NameColor, setter: false},
      color_to: {type: SRcr::NameColor, setter: false}
    )
  end
  class NameColor
    JSON.mapping(
      light: {type: Int64, converter: SRcr::NameColorToIntConverter, setter: false},
      dark: {type: Int64, converter: SRcr::NameColorToIntConverter, setter: false}
    )
  end
  class NameColorToIntConverter
    def self.from_json(value : JSON::PullParser) : Int
      value.read_string[1..-1].to_i(16)
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
