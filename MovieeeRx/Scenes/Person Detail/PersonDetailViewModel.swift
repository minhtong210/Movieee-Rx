import RxCocoa
import RxSwift
import MGArchitecture

//MARK: - Data Source
struct PersonDetailViewModel {
    let navigator: PersonDetailNavigatorType
    let useCase: PersonDetailUseCaseType
    let personId: Int
}

//MARK: - ViewModelType

extension PersonDetailViewModel: ViewModel {
    struct Input {
        let loadTrigger: Driver<Void>
        let backTrigger: Driver<Void>
        let knownForTrigger: Driver<IndexPath>
    }
    
    struct Output {
        let personDetail: Driver<PersonDetail>
        let personKnownFor: Driver<[Movie]>
        let toMovieDetail: Driver<Void>
        let toBackView: Driver<Void>
    }
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        
        let personDetail = input.loadTrigger
            .flatMapLatest {
                useCase.getPersonDetail(from: personId)
                    .asDriverOnErrorJustComplete()
            }
        
        let personKnownFor = input.loadTrigger
            .flatMapLatest {
                useCase.getPersonKnownFor(from: personId)
                    .asDriverOnErrorJustComplete()
            }
        
        let toMovieDetail = input.knownForTrigger
            .withLatestFrom(personKnownFor) {
                navigator.toMovieDetail(movieId: $1[$0.row].id)
            }
            .asDriver()
        
        let toBackView = input.backTrigger
            .do(onNext: {
                navigator.toBackView()
            })
            .mapToVoid()
        
        return Output(personDetail: personDetail,
                      personKnownFor: personKnownFor,
                      toMovieDetail: toMovieDetail,
                      toBackView: toBackView)
    }
    
}
