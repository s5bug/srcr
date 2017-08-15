require "json"

module SRcr
  class User
    JSON.mapping(
      id: {type: String, setter: false},
      names: {type: SRcr::UserNameSet, setter: false},
      weblink: {type: String, setter: false},
      name_style: {type: SRcr::NameStyle, key: "name-style", setter: false},
      role: {type: SRcr::UserRole, converter: SRcr::StringToUserRoleConverter, setter: false}
    )
  end
  class UserNameSet
    JSON.mapping(
      international: {type: String, setter: false},
      japanese: {type: String, nilable: true, setter: false}
    )
  end
  class NameStyle
    JSON.mapping(
      color_from: {type: SRcr::NameColor, setter: false},
      color_to: {type: SRcr::NameColor, setter: false}
    )
  end
  class NameColor
    JSON.mapping(
      light: {type: Int, converter: SRcr::NameColorToIntConverter, setter: false},
      dark: {type: Int, converter: SRcr::NameColorToIntConverter, setter: false}
    )
  end
  class NameColorToIntConverter
    def self.from_json(value : JSON::PullParser) : Int
      value.read_string[1..-1].to_i(16)
    end
    def self.to_json(value : Int, json : JSON::Builder)
      ("#" + value.to_s(16)).to_json(json)
    end
  end
end
