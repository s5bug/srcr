require "../srcr"
require "./users"
require "json"

module SRcr
  class Game
    JSON.mapping(
      id: {type: String, setter: false},
      names: {type: SRcr::GameNameSet, setter: false},
      abbreviation: {type: String, nilable: true, setter: false},
      weblink: {type: URI, converter: SRcr::StringToURIConverter, setter: false},
      released: {type: Int64, setter: false, getter: false},
      release_date: {type: Time, key: "release-date", converter: Time::Format.new("%Y-%m-%d"), setter: false},
      ruleset: {type: SRcr::Ruleset, setter: false},
      romhack: {type: Bool, setter: false}, # Deprecated, will be removed from mapping on release
      gametypes: {type: Array(String), setter: false},
      platforms: {type: Array(String), setter: false, getter: false}, # TODO getter
      regions: {type: Array(String), setter: false, gettter: false}, # TODO getter
      genres: {type: Array(String), setter: false},
      engines: {type: Array(String), setter: false},
      developers: {type: Array(String), setter: false},
      publishers: {type: Array(String), setter: false},
      moderators: {type: Hash(String, String), setter: false, getter: false},
      created: {type: Time, nilable: true, converter: Time::Format.new("%Y-%m-%dT%H:%M:%SZ"), setter: false},
      assets: {type: SRcr::Assets, setter: false},
      links: {type: Array(SRcr::Link), setter: false}
    )

    def self.from_id(id : String) : Game
      SRcr::Game.from_json(SRcr::CLIENT.get(SRcr::API_ROOT + "games/" + id).body, "data")
    end

    def self.search(name : String) : Array(Game)
      Array(SRcr::Game).from_json(SRcr::CLIENT.get(SRcr::API_ROOT + "games?name=" + URI.escape(name, true)).body, "data")
    end

    def moderators : Hash(SRcr::User, SRcr::ModeratorType)
      mod_mapped = {} of SRcr::User => SRcr::ModeratorType
      @moderators.each do |k, v|
        mod_mapped[SRcr::User.from_id(k)] = SRcr::StringToModeratorTypeConverter.from_string(v)
      end
      mod_mapped
    end

    def released : Time
      Time.format("%Y").from_json(@released.to_s)
    end

    def categories : Array(SRcr::Category)
      Array(SRcr::Category).from_json(SRcr::CLIENT.get(SRcr::API_ROOT + "games/#{id}/categories").body, "data")
    end
  end
  class GameNameSet
    JSON.mapping(
      international: {type: String, setter: false},
      japanese: {type: String, nilable: true, setter: false},
      twitch: {type: String, nilable: true, setter: false}
    )
  end
  class Ruleset
    JSON.mapping(
      show_milliseconds: {type: Bool, key: "show-milliseconds", setter: false},
      require_verification: {type: Bool, key: "require-verification", setter: false},
      require_video: {type: Bool, key: "require-video", setter: false},
      run_times: {type: Array(SRcr::TimeType), key: "run-times", converter: SRcr::StringArrayToTimeTypeArrayConverter, setter: false},
      default_time: {type: SRcr::TimeType, key: "default-time", converter: SRcr::StringToTimeTypeConverter, setter: false},
      emulators_allowed: {type: Bool, key: "emulators-allowed", setter: false}
    )
  end
  class Assets
    JSON.mapping(
      logo: {type: SRcr::Image, setter: false},
      cover_tiny: {type: SRcr::Image, key: "cover-tiny", setter: false},
      cover_small: {type: SRcr::Image, key: "cover-small", setter: false},
      cover_medium: {type: SRcr::Image, key: "cover-medium", setter: false},
      cover_large: {type: SRcr::Image, key: "cover-large", setter: false},
      icon: {type: SRcr::Image, setter: false},
      trophy_1st: {type: SRcr::Image, key: "trophy-1st", setter: false},
      trophy_2nd: {type: SRcr::Image, key: "trophy-2nd", setter: false},
      trophy_3rd: {type: SRcr::Image, key: "trophy-3rd", setter: false},
      trophy_4th: {type: SRcr::Image, nilable: true, key: "trophy-4th", setter: false},
      background: {type: SRcr::Image, nilable: true, setter: false},
      foreground: {type: SRcr::Image, nilable: true, setter: false}
    )
  end

  class Category
    JSON.mapping(
      id: {type: String, setter: false},
      name: {type: String, setter: false},
      weblink: {type: URI, converter: SRcr::StringToURIConverter, setter: false},
      type: {type: String, setter: false, getter: false},
      rules: {type: String, setter: false},
      players: {type: SRcr::PlayerRules, setter: false},
      miscellaneous: {type: Bool, setter: false},
      links: {type: Array(SRcr::Resource), setter: false}
    )

    def self.from_id(id : String) : SRcr::Category
      SRcr::Category.from_json(SRcr::CLIENT.get(SRcr::API_ROOT + "categories/" + id).body, "data")
    end

    def game
      gl = links.select do |l|
        l.rel == "game"
      end
      id = gl.split("/")[-1]
      SRcr::Game.from_id(id)
    end

    def type
      case @type
      when "per-level"
        SRcr::CategoryType::Level
      else
        SRcr::CategoryType::Game
      end
    end
  end
  enum CategoryType
    Game
    Level
  end
  class PlayerRules
    JSON.mapping(
      type: {type: String, setter: false, getter: false}, # TODO getter
      value: {type: Int64, setter: false}
    )
  end
  enum ModeratorType # TODO add notmoderator
    SuperModerator
    Moderator
  end
  class StringToModeratorTypeConverter
    def self.from_json(value : JSON::Builder) : SRcr::ModeratorType
      self.from_string(value.read_string)
    end

    def self.from_string(value : String) : SRcr::ModeratorType
      case value
      when "super-moderator"
        SRcr::ModeratorType::SuperModerator
      else
        SRcr::ModeratorType::Moderator
      end
    end

    def self.to_json(value : SRcr::ModeratorType, json : JSON::Builder)
      self.to_string(value).to_json(json)
    end

    def self.to_string(value : SRcr::ModeratorType) : String
      case value
      when SRcr::ModeratorType::SuperModerator
        "super-moderator"
      else
        "moderator"
      end
    end
  end
end
