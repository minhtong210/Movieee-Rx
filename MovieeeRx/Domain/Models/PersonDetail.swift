import ObjectMapper

struct PersonDetail {
    var id = 0
    var name = ""
    var image = ""
    var department = ""
    var gender = Gender.female
    var birthday = ""
    var biography = ""
    
    enum Gender: Int {
        case female = 1
        case male = 2
        var kind: String {
            switch self {
                case .male: return "Male"
                case .female: return "Female"
            }
        }
    }
}

extension PersonDetail: BaseModel {
    
    init?(map: Map) {
        self.init()
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        image <- map["profile_path"]
        department <- map["known_for_department"]
        gender <- map["gender"]
        birthday <- map["birthday"]
        biography <- map["biography"]
    }
}


