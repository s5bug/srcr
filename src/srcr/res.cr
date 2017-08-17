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
      width: {type: Int64, setter: false},
      height: {type: Int64, setter: false}
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
  class NameSet
    JSON.mapping(
      international: {type: String, setter: false},
      japanese: {type: String, nilable: true, setter: false}
    )
  end
  class Location
    JSON.mapping(
      country: {type: SRcr::CodedLocation, setter: false},
      region: {type: SRcr::CodedLocation, nilable: true, setter: false}
    )
  end
  class CodedLocation
    JSON.mapping(
      code: {type: String, setter: false},
      names: {type: SRcr::NameSet, setter: false}
    )
  end
end
