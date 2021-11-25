import ObjectMapper

struct Genre {
    var id = 0
    var name = ""
}

extension Genre: BaseModel {
    init?(map: Map) {
        self.init()
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
    }
}
