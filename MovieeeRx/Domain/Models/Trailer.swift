import ObjectMapper

struct Trailer {
    var key = ""
}

extension Trailer: BaseModel {
    
    init?(map: Map) {
        self.init()
    }
    
    mutating func mapping(map: Map) {
        key <- map["key"]
    }
}
