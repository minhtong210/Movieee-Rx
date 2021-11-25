import RxCocoa
import RxSwift
import MGArchitecture

//MARK: - Data Source
struct TrailerViewModel {
    let navigator: TrailerNavigatorType
    let useCase: TrailerUseCaseType
    let movieId: Int
}

//MARK: - ViewModelType

extension TrailerViewModel: ViewModel {
    struct Input {
        let loadTrigger: Driver<Void>
        let backTrigger: Driver<Void>
    }
    
    struct Output {
        let toBackView: Driver<Void>
        let trailerKey: Driver<String>
    }
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        
        let trailerKey = input.loadTrigger
            .flatMapLatest {
                useCase.getMovieTrailers(from: movieId)
                    .asDriverOnErrorJustComplete()
            }
            .map { $0[0].key }
        
        
        let toBackView = input.backTrigger
            .do(onNext: {
                navigator.toBackView()
            })
            .mapToVoid()
        
        return Output(toBackView: toBackView,
                      trailerKey: trailerKey)
    }
    
}
