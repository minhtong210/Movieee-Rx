import RxCocoa
import RxSwift
import MGArchitecture

//MARK: - Data Source
struct FavoriteViewModel {
    let navigator: FavoriteNavigatorType
    let useCase: FavoriteUseCaseType
}

//MARK: - ViewModelType

extension FavoriteViewModel: ViewModel {
    struct Input {
        let loadTrigger: Driver<Void>
        let searchTrigger: Driver<Void>
        let movieDetailTrigger: Driver<IndexPath>
        let deleteTrigger: Driver<FavoriteMovie>
        let notification: Driver<Int>
    }
    
    struct Output {
        let items: Driver<[FavoriteMovie]>
        let navigation: Driver<Void>
    }
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        let loadItems = input.loadTrigger
            .flatMapLatest {
                useCase.fetchFavoriteMovies()
                    .asDriverOnErrorJustComplete()
            }
        
        let deleteItem = input.deleteTrigger
            .flatMapLatest {
                useCase.deleteFavoriteMovie($0)
                    .asDriverOnErrorJustComplete()
            }
            .flatMapLatest {
                useCase.fetchFavoriteMovies()
                    .asDriverOnErrorJustComplete()
            }
            
        let notification = input.notification
            .flatMapLatest { _ in
                useCase.fetchFavoriteMovies()
                    .asDriverOnErrorJustComplete()
            }
        
        let items = Driver.merge(loadItems, deleteItem, notification)
        
        let toSearch = input.searchTrigger
            .do(onNext: {
                navigator.toSearch()
            })
        
        let toMovieDetail = input.movieDetailTrigger
            .withLatestFrom(items) {
                navigator.toMovieDetail(movieId: $1[$0.row].id)
            }
            .asDriver()
        
        let navigation = Driver.merge(toSearch, toMovieDetail)
        
        return Output(items: items,
                      navigation: navigation)
    }
    
}
