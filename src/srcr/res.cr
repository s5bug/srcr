require "json"

module SRcr
  class Link
    JSON.mapping(
      uri: {type: String, setter: false}
    )
  end
end
