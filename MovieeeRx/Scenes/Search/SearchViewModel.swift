import RxCocoa
import RxSwift
import MGArchitecture

//MARK: - Data Source

struct SearchViewModel {
    let navigator: SearchNavigatorType
    let useCase: SearchUseCaseType
}

//MARK: - ViewModelType

extension SearchViewModel: ViewModel {
    struct Input {
        let loadTrigger: Driver<Void>
        let searchTrigger: Driver<Void>
        let searchBarReturn: Driver<Void>
        let movieDetailTrigger: Driver<IndexPath>
        let searchText: Driver<String>
        let backTrigger: Driver<Void>
    }
    
    struct Output {
        let navigation: Driver<Void>
        let movies: Driver<[MovieSearch]>
        let isEmptyResult: Driver<Bool>
    }
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        
        let movies = Driver.merge(input.searchTrigger, input.searchBarReturn)
            .withLatestFrom(input.searchText)
            .flatMapLatest {
                useCase.getMoviesSearch(query: $0)
                    .asDriverOnErrorJustComplete()
            }

        let isEmptyResult = movies
            .map { $0.isEmpty }
            .asDriver()
        
        let toMovieDetail = input.movieDetailTrigger
            .withLatestFrom(movies) {
                navigator.toMovieDetail(movieId: $1[$0.row].id)
            }
        
        let toBackView = input.backTrigger
            .do(onNext: {
                navigator.toBackView()
            })
        
        let navigation = Driver.merge(toBackView, toMovieDetail)
        
        return Output(navigation: navigation,
                      movies: movies,
                      isEmptyResult: isEmptyResult)
    }
    
}
