require "../srcr"
require "json"

module SRcr
  class Game
    JSON.mapping(
      id: {type: String, setter: false},
      names: {type: SRcr::NameSet, setter: false},
      abbreviation: {type: String, nilable: true, setter: false},
      weblink: {type: URI, converter: SRcr::StringToURIConverter, setter: false},
      released: {type: Time, converter: Time::Format.new("%Y"), setter: false},
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
      moderators: {type: Hash(String, String), setter: false, getter: false}, # TODO getter
      created: {type: Time, converter: Time::Format.new("%Y-%m-%dT%H:%M:%SZ"), setter: false},
      assets: {type: SRcr::Assets, setter: false},
      links: {type: Array(SRcr::Link), setter: false}
    )
  end
  class NameSet
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
      run_times: {type: Array(SRcr::TimeType), key: "run-times", converter: SRcr::StringToTimeTypeConverter, setter: false},
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
      background: {type: SRcr::Image, setter: false},
      foreground: {type: SRcr::Image, nilable: true, setter: false}
    )
  end
end
