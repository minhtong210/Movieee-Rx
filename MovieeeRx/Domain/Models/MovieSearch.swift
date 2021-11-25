import ObjectMapper

struct MovieSearch {
    var id = 0
    var title = ""
    var poster = ""
    var overview = ""
    var rate = 0.0
}

extension MovieSearch: BaseModel {
    
    init?(map: Map) {
        self.init()
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        poster <- map["poster_path"]
        overview <- map["overview"]
        rate <- map["vote_average"]
    }
}
