require "json"

module SRcr
  class User
    JSON.mapping(
      id: {type: String, setter: false},
      names: {type: SRcr::UserNameSet, setter: false},
      weblink: {type: String, setter: false},
      name_style: {type: SRcr::NameStyle, key: "name-style", setter: false},

    )
  end
  class UserNameSet
    JSON.mapping(
      international: {type: String, setter: false},
      japanese: {type: String, nilable: true, setter: false}
    )
  end
  class NameStyle
    # TODO color_from, color_to
  end
end
