final class SearchRequest: BaseRequest {
    
    required init(query: String) {
        let body: [String: Any] = [
            "api_key": APIKey.APIkey,
            "query": query
        ]
        super.init(url: URLs.API.movieSearch, requestType: .get, body: body)
    }
}
