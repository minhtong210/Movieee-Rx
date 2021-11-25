import RxCocoa
import RxSwift
import MGArchitecture

//MARK: - Data Source
struct MovieDetailViewModel {
    let navigator: MovieDetailNavigatorType
    let useCase: MovieDetailUseCaseType
    let movieId: Int
}

//MARK: - ViewModelType

extension MovieDetailViewModel: ViewModel {
    struct Input {
        let loadTrigger: Driver<Void>
        let backTrigger: Driver<Void>
        let favoriteTrigger: Driver<Void>
        let trailerTrigger: Driver<Void>
        let personTrigger: Driver<IndexPath>
        let genreTrigger: Driver<IndexPath>
        let notification: Driver<Int>
    }
    
    struct Output {
        let movieDetail: Driver<MovieDetail>
        let movieGenres: Driver<[Genre]>
        let movieCast: Driver<[Person]>
        let favoriteTrigger: Driver<Bool>
        let notification: Driver<Bool>
        let navigation: Driver<Void>
    }
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        
        let movieDetail = input.loadTrigger
            .flatMapLatest {
                useCase.getMovieDetail(from: movieId)
                    .asDriverOnErrorJustComplete()
            }

        
        let notification = input.notification
            .withLatestFrom(movieDetail)
            .flatMapLatest {
                useCase.checkFavoriteMovie($0)
                    .asDriverOnErrorJustComplete()
            }
        
        let favoriteTrigger = input.favoriteTrigger
            .withLatestFrom(movieDetail)
            .flatMapLatest {
                useCase.favoriteButtonBehavior(movie: $0)
                    .asDriverOnErrorJustComplete()
            }
            .withLatestFrom(movieDetail)
            .flatMapLatest {
                useCase.checkFavoriteMovie($0)
                    .asDriverOnErrorJustComplete()
            }
        
        let movieGenres = movieDetail
            .map { $0.genres }
            .asDriver()
        
        let movieCast = input.loadTrigger
            .flatMapLatest {
                useCase.getMovieActors(from: movieId)
                    .asDriverOnErrorJustComplete()
            }

        let toPersonDetail = input.personTrigger
            .withLatestFrom(movieCast) {
                navigator.toPersonDetail(personId: $1[$0.row].id)
            }
            .asDriver()
        
        let toCateGenreDetail = input.genreTrigger
            .withLatestFrom(movieDetail) {
                navigator.toCateGenreDetail(genre: $1.genres[$0.row])
            }
        
        let toTrailer = input.trailerTrigger
            .do(onNext: {
                navigator.toTrailer(movieId: movieId)
            })
        
        let toBackView = input.backTrigger
            .do(onNext: {
                navigator.toBackView()
            })
        
        let navigation = Driver.merge(toPersonDetail, toTrailer, toBackView, toCateGenreDetail)
        
        return Output(movieDetail: movieDetail,
                      movieGenres: movieGenres,
                      movieCast: movieCast,
                      favoriteTrigger: favoriteTrigger,
                      notification: notification,
                      navigation: navigation)
    }
}
