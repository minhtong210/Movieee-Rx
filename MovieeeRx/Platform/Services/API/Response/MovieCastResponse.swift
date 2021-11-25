import ObjectMapper

final class MovieCastResponse: BaseModel {
    var actors = [Person]()
    
    required init(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        actors <- map["cast"]
    }
}
