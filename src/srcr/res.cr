require "json"

module SRcr
  class Link
    JSON.mapping(
      uri: {type: URI, converter: SRcr::StringToURIConverter, setter: false}
    )
  end
  class Resource < Link
    JSON.mapping(
      rel: {type: String, setter: false},
      uri: {type: URI, converter: SRcr::StringToURIConverter, setter: false}
    )
  end
  class Image < Link
    JSON.mapping(
      uri: {type: URI, converter: SRcr::StringToURIConverter, setter: false},
      width: {type: Int, setter: false},
      height: {type: Int, setter: false}
    )
  end
  class System
    JSON.mapping(
      platform: {type: String, getter: false, setter: false},
      emulated: {type: Bool, setter: false},
      region: {type: String, nilable: true, setter: false}
    )
  end
  enum TimeType
    Primary
    Realtime
    RealtimeNoLoads
    Ingame
  end
end
