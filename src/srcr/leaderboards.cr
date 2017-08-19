require "json"
require "./runs"
require "./res"
require "../srcr"

module SRcr
  class PlacedRun
    JSON.mapping(
      place: {type: Int64, setter: false},
      run: {type: SRcr::Run, setter: false}
    )
  end
  class Leaderboard
    JSON.mapping(
      weblink: {type: URI, converter: SRcr::StringToURIConverter, setter: false},
      game: {type: String, setter: false, getter: false}, # TODO getter
      category: {type: String, setter: false, getter: false}, # TODO getter
      level: {type: String, nilable: true, setter: false, getter: false}, # TODO getter
      platform: {type: String, nilable: true, setter: false, getter: false}, # TODO getter
      region: {type: String, nilable: true, setter: false, getter: false},
      emulators: {type: Bool, nilable: true, setter: false},
      video_only: {type: Bool, setter: false},
      timing: {type: SRcr::TimeType, converter: SRcr::StringToTimeTypeConverter, setter: false},
      values: {type: Hash(String, String), setter: false, getter: false}, # TODO getter
      runs: {type: Array(SRcr::PlacedRun), setter: false},
      links: {type: Array(SRcr::Resource), setter: false}
    )

    def self.from_category(c : SRcr::Category)
      SRcr::Leaderboard.from_json(SRcr::CLIENT.get(SRcr::API_ROOT + "leaderboards/" + c.game.id + "/category/" + c.id).body, "data")
    end
  end
end
