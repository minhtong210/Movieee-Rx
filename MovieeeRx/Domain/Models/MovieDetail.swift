import ObjectMapper

struct MovieDetail {
    var id = 0
    var title = ""
    var poster = ""
    var overview = ""
    var genres = [Genre]()
    var voteAverage = 0.0
    var runtime = 0
    var releaseDay = ""
}

extension MovieDetail: BaseModel {
    
    init?(map: Map) {
        self.init()
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        poster <- map["poster_path"]
        overview <- map["overview"]
        genres <- map["genres"]
        voteAverage <- map["vote_average"]
        runtime <- map["runtime"]
        releaseDay <- map["release_date"]
    }
}
