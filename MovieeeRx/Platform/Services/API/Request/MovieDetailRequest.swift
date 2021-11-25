final class MovieDetailRequest: BaseRequest {
    
    required init(movieId: Int) {
        let body: [String: Any] = [
            "api_key": APIKey.APIkey
        ]
        let urlString = String(format: URLs.API.movieDetail, movieId)
        super.init(url: urlString, requestType: .get, body: body)
    }
}
