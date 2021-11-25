final class GenreDetailRequest: BaseRequest {
    
    required init(genreId: Int) {
        let body: [String: Any] = [
            "api_key": APIKey.APIkey,
            "with_genres": genreId
        ]
        let urlString = String(format: URLs.API.moviesByGenre)
        super.init(url: urlString, requestType: .get, body: body)
    }
}
