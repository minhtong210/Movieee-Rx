import RxCocoa
import RxSwift

protocol PersonDetailUseCaseType {
    func getPersonDetail(from personId: Int) -> Observable<PersonDetail>
    func getPersonKnownFor(from personId: Int) -> Observable<[Movie]>
}

struct PersonDetailUseCase: PersonDetailUseCaseType {
    private let repository = PersonDetailRepository()
    
    func getPersonDetail(from personId: Int) -> Observable<PersonDetail> {
        let request = PersonDetailRequest(personId: personId)
        return repository.getPersonDetail(input: request)
    }
    
    func getPersonKnownFor(from personId: Int) -> Observable<[Movie]> {
        let request = PersonKnownForRequest(personId: personId)
        return repository.getPersonKnownFor(input: request)
    }
}
