import ObjectMapper

final class MoviesResponse: BaseModel {
    var movies = [Movie]()
    
    required init(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        movies <- map["results"]
    }
}
