import ObjectMapper

struct Person {
    var id = 0
    var name = ""
    var image = ""
}

extension Person: BaseModel {
    
    init?(map: Map) {
        self.init()
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        image <- map["profile_path"]
    }
}
