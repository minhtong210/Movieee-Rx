import ObjectMapper

final class TrailerResponse: BaseModel {
    var results = [Trailer]()
    
    required init(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        results <- map["results"]
    }
}
