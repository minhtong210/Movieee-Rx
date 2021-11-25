import ObjectMapper

final class PersonKnownForResponse: BaseModel {
    var knownFor = [Movie]()
    
    required init(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        knownFor <- map["cast"]
    }
}
