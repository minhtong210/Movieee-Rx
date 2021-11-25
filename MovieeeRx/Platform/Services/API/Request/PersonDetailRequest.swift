final class PersonDetailRequest: BaseRequest {
    
    required init(personId: Int) {
        let body: [String: Any] = [
            "api_key": APIKey.APIkey
        ]
        let urlString = String(format: URLs.API.personDetail, personId)
        super.init(url: urlString, requestType: .get, body: body)
    }
}
