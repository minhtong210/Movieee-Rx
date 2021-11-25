import RxCocoa
import RxSwift

protocol FavoriteUseCaseType {
    func fetchFavoriteMovies() -> Observable<[FavoriteMovie]>
    func deleteFavoriteMovie(_ movie: FavoriteMovie) -> Observable<Void>
}

struct FavoriteUseCase: FavoriteUseCaseType {
    private let repository = FavoriteRepository()
    
    func fetchFavoriteMovies() -> Observable<[FavoriteMovie]> {
        return repository.fetchFavoriteMovies()
    }
    
    func deleteFavoriteMovie(_ movie: FavoriteMovie) -> Observable<Void> {
        return repository.deleteFavoriteMovie(movie).andThen(.just(()))
    }
}
