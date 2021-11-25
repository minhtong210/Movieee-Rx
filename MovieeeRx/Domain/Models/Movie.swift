import ObjectMapper

struct Movie {
    var id = 0
    var title = ""
    var poster = ""
}

extension Movie: BaseModel {
    init?(map: Map) {
        self.init()
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        poster <- map["poster_path"]
    }
}

