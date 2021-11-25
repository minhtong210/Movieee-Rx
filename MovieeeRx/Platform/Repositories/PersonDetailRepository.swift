import RxCocoa
import RxSwift

protocol PersonDetailRepositoryType {
    func getPersonDetail(input: PersonDetailRequest) -> Observable<PersonDetail>
    func getPersonKnownFor(input: PersonKnownForRequest) -> Observable<[Movie]>
}

final class PersonDetailRepository: PersonDetailRepositoryType {
    private let api = APIService.share
    
    func getPersonDetail(input: PersonDetailRequest) -> Observable<PersonDetail> {
        return api.request(input: input)
    }
    
    func getPersonKnownFor(input: PersonKnownForRequest) -> Observable<[Movie]> {
        return api.request(input: input)
            .map { (response: PersonKnownForResponse) in
                return response.knownFor
            }
    }
}
