final class MovieSearchRequest: BaseRequest {
    
    required init(query: String) {
        let body: [String: Any] = [
            "api_key": APIKey.APIkey,
            "query": query
        ]
        let urlString = String(format: URLs.API.movieSearch)
        super.init(url: urlString, requestType: .get, body: body)
    }
}
