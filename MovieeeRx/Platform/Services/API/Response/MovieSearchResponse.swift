import ObjectMapper

final class MoviesSearchResponse: BaseModel {
    var movies = [MovieSearch]()
    
    required init(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        movies <- map["results"]
    }
}
