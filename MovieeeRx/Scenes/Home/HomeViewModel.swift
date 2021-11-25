import RxCocoa
import RxSwift
import MGArchitecture

//MARK: - Data Source
struct HomeCellType {
    var category: CategoryType
    var movies: [Movie]
}

struct HomeViewModel {
    let navigator: HomeNavigatorType
    let useCase: HomeUseCaseType
}

//MARK: - ViewModelType

extension HomeViewModel: ViewModel {
    struct Input {
        let loadTrigger: Driver<Void>
        let searchTrigger: Driver<Void>
        let movieDetailTrigger: Driver<Movie>
    }
    
    struct Output {
        let items: Driver<[HomeCellType]>
        let navigation: Driver<Void>
    }
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        
        let nowPlayingMovies = input.loadTrigger
            .flatMapLatest {
                useCase.getNowPlayingMovies()
                    .asDriverOnErrorJustComplete()
            }
        
        let upcomingMovies = input.loadTrigger
            .flatMapLatest {
                useCase.getUpcomingMovies()
                    .asDriverOnErrorJustComplete()
            }
        
        let popularMovies = input.loadTrigger
            .flatMapLatest {
                useCase.getPopularMovies()
                    .asDriverOnErrorJustComplete()
            }
        
        let topRatedMovies = input.loadTrigger
            .flatMapLatest {
                useCase.getTopRatedMovies()
                    .asDriverOnErrorJustComplete()
            }
        
        let items = Driver.combineLatest(popularMovies,
                                         nowPlayingMovies,
                                         upcomingMovies,
                                         topRatedMovies)
            .map { popular, nowPlaying, upcoming, topRated -> [HomeCellType] in
                useCase.mergeItems(nowPlayingMovies: nowPlaying,
                                   topRatedMovies: topRated,
                                   popularMovies: popular,
                                   upcomingMovies: upcoming)
            }
        
        let toMovieDetail = input.movieDetailTrigger
            .do(onNext: {
                navigator.toMovieDetail(movieId: $0.id)
            })
            .mapToVoid()
        
        let toSearch = input.searchTrigger
            .do(onNext: {
                navigator.toSearch()
            })
        
        let navigation = Driver.merge(toMovieDetail, toSearch)
        
        return Output(items: items,
                      navigation: navigation)
    }
    
}
