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
      ruleset: {type: SRcr::Ruleset, setter: false}
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
      require_verification: {type: Bool, key: "require-verification", setter: false}
    )
  end
end
