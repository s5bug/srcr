require "json"

module SRcr
  class Link
    JSON.mapping(
      uri: {type: URI, converter: SRcr::StringToURIConverter, setter: false}
    )
  end
end
