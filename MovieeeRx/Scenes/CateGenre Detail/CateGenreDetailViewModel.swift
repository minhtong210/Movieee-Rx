import RxCocoa
import RxSwift
import MGArchitecture

//MARK: - Data Source
enum DetailType {
    case category
    case genre
}

struct CateGenreViewModel {
    let navigator: CateGenreNavigatorType
    let useCase: CateGenreUseCaseType
    let category: CategoryType?
    let genre: Genre?
}

//MARK: - ViewModelType

extension CateGenreViewModel: ViewModel {
    struct Input {
        let loadTrigger: Driver<Void>
        let backTrigger: Driver<Void>
        let movieTrigger: Driver<IndexPath>
    }
    
    struct Output {
        let title: Driver<String>
        let movies: Driver<[Movie]>
        let navigation: Driver<Void>
    }
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        
        let movies = input.loadTrigger
            .flatMapLatest {
                useCase.getMovies(from: category, or: genre?.id)
                    .asDriverOnErrorJustComplete()
            }

        let title = input.loadTrigger
            .flatMapLatest {
                useCase.getTitle(from: category, or: genre)
                    .asDriverOnErrorJustComplete()
            }
        
        let toMovieDetail = input.movieTrigger
            .withLatestFrom(movies) {
                navigator.toMovieDetail(movieId: $1[$0.row].id)
            }
        
        let toBackView = input.backTrigger
            .do(onNext: {
                navigator.toBackView()
            })
            .mapToVoid()
        
        let navigation = Driver.merge(toBackView, toMovieDetail)
        
        return Output(title: title,
                      movies: movies,
                      navigation: navigation)
    }
    
}
