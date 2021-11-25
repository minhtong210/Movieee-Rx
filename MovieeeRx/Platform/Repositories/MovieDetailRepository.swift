import RxCocoa
import RxSwift

protocol MovieDetailRepositoryType {
    func getMovieDetail(input: MovieDetailRequest) -> Observable<MovieDetail>
    func getMovieCast(input: MovieCastRequest) -> Observable<[Person]>
    func checkFavoriteMovie(_ item: MovieDetail) -> Bool
    func insertFavoriteMovie(from movie: MovieDetail,
                             newFavorite: @escaping () -> FavoriteMovie) -> Completable
    func deleteFavoriteMovie(from movieId: Int) -> Completable
}

final class MovieDetailRepository: MovieDetailRepositoryType {
    
    private let api = APIService.share
    private let realm = RealmService.share
    
    func getMovieDetail(input: MovieDetailRequest) -> Observable<MovieDetail> {
        return api.request(input: input)
    }
    
    func getMovieCast(input: MovieCastRequest) -> Observable<[Person]> {
        return api.request(input: input)
            .map { (response: MovieCastResponse) in
                return response.actors
            }
    }
    
    func insertFavoriteMovie(from movie: MovieDetail,
                             newFavorite: @escaping () -> FavoriteMovie) -> Completable {
        return realm.insert(newElement: newFavorite)
    }
    
    func checkFavoriteMovie(_ movie: MovieDetail) -> Bool {
        return realm.checkFavoriteMovie(movieId: movie.id)
    }
    
    func deleteFavoriteMovie(from movieId: Int) -> Completable {
        return realm.delete(movieId: movieId)
    }
}
