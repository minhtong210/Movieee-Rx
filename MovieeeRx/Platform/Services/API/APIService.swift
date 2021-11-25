import Foundation
import RxSwift
import Alamofire
import ObjectMapper

struct APIService {
    
    static let share = APIService()
    
    private var alamofireManager = Alamofire.Session.default
    
    init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 30
        alamofireManager = Alamofire.Session(configuration: configuration)
    }
    
    func request<T: BaseModel>(input: BaseRequest) ->  Observable<T> {
        return Observable.create { observer in
            self.alamofireManager.request(input.url,
                                          method: input.requestType,
                                          parameters: input.body,
                                          encoding: input.encoding)
                .validate(statusCode: 200..<500)
                .responseJSON { response in
                    switch response.result {
                    case .success(let value):
                        if let statusCode = response.response?.statusCode {
                            if statusCode == 200 {
                                if let object = Mapper<T>().map(JSONObject: value) {
                                    observer.onNext(object)
                                    observer.onCompleted()
                                }
                            } else {
                                if let error = Mapper<ErrorResponse>().map(JSONObject: value) {
                                    observer.onError(BaseError.apiFailure(error: error))
                                } else {
                                    observer.onError(BaseError.httpError(httpCode: statusCode))
                                }
                            }
                        } else {
                            observer.onError(BaseError.unexpectedError)
                        }
                    case .failure:
                        observer.onError(BaseError.networkError)
                    }
            }
            return Disposables.create()
        }
    }
    
}
