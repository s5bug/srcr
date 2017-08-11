require "json"

module SRcr
  class Link
    JSON.mapping(
      uri: {type: URI, converter: SRcr::StringToURIConverter, setter: false}
    )
  end
  class System
    JSON.mapping(
      platform: {type: String, getter: false, setter: false},
      emulated: {type: Bool, setter: false},
      region: {type: String, nilable: true, setter: false}
    )
  end
end
