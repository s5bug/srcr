require "../srcr"
require "json"

module SRcr
  class Run
    JSON.mapping {
      @id: String
      @weblink: {type: URI, converter: SRcr::StringToURIConverter}
      @game
    }
  end
end
