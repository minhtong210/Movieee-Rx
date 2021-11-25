import RxCocoa
import RxSwift

protocol MovieDetailUseCaseType {
    func getMovieDetail(from movieId: Int) -> Observable<MovieDetail>
    func getMovieActors(from movieId: Int) -> Observable<[Person]>
    func checkFavoriteMovie(_ movie: MovieDetail) -> Observable<Bool>
    func favoriteButtonBehavior(movie: MovieDetail) -> Observable<Void>
}

struct MovieDetailUseCase: MovieDetailUseCaseType {
    private let repository = MovieDetailRepository()
    
    func getMovieDetail(from movieId: Int) -> Observable<MovieDetail> {
        let request = MovieDetailRequest(movieId: movieId)
        return repository.getMovieDetail(input: request)
    }
    
    func getMovieActors(from movieId: Int) -> Observable<[Person]> {
        let request = MovieCastRequest(movieId: movieId)
        return repository.getMovieCast(input: request)
    }
    
    func checkFavoriteMovie(_ movie: MovieDetail) -> Observable<Bool> {
        return Observable.just(repository.checkFavoriteMovie(movie))
    }
    
    func favoriteButtonBehavior(movie: MovieDetail) -> Observable<Void> {
        if repository.checkFavoriteMovie(movie) {
            return repository.deleteFavoriteMovie(from: movie.id)
                .andThen(.just(()))
        } else {
            return repository.insertFavoriteMovie(from: movie) {
                let newFavoriteMovie = FavoriteMovie().then {
                    $0.id = movie.id
                    $0.name = movie.title
                    $0.overview = movie.overview
                    $0.poster = movie.poster
                    $0.rate = movie.voteAverage
                }
                return newFavoriteMovie
            }.andThen(.just(()))
        }
        
    }
}
