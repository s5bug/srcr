require "json"

module SRcr
  class User
    JSON.mapping(
      id: {type: String, setter: false},
      names: {type: SRcr::UserNameSet, setter: false},
      weblink: {type: String, setter: false},
      # TODO
    )
  end
  class UserNameSet
    JSON.mapping(
      international: {type: String, setter: false},
      japanese: {type: String, nilable: true, setter: false}
    )
  end
end
