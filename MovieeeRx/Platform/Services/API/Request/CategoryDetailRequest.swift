final class CategoryDetailRequest: BaseRequest {
    
    required init(category: CategoryType) {
        let body: [String: Any] = [
            "api_key": APIKey.APIkey
        ]
        super.init(url: category.url, requestType: .get, body: body)
    }
}
