require "../srcr"
require "./res"
require "json"

module SRcr
  class Run
    JSON.mapping(
      id: {type: String, setter: false},
      weblink: {type: URI, converter: SRcr::StringToURIConverter, setter: false},
      game: {type: String, getter: false, setter: false},
      level: {type: String, nilable: true, getter: false, setter: false},
      category: {type: String, setter: false},
      videos: {type: SRcr::VideoListing, setter: false}
    )
  end
  class VideoListing
    JSON.mapping(
      text: {type: String, setter: false},
      links: {type: Array(SRcr::Link), setter: false}
    )
  end
end
