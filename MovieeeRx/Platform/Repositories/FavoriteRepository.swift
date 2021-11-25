import RxCocoa
import RxSwift
import RealmSwift

protocol FavoriteRepositoryType {
    func insertFavoriteMovie(from movie: FavoriteMovie,
                             newFavorite: @escaping () -> Object) -> Completable
//    func checkFavoriteMovie(_ category: Category, update: @escaping () -> Void) -> Completable
    func fetchFavoriteMovies() -> Observable<[FavoriteMovie]>
    func deleteFavoriteMovie(_ movie: FavoriteMovie) -> Completable
}

final class FavoriteRepository: FavoriteRepositoryType {
    private let realm = RealmService.share
    
    func insertFavoriteMovie(from movie: FavoriteMovie,
                             newFavorite: @escaping () -> Object) -> Completable {
        return realm.insert(newElement: newFavorite)
    }
    
    func fetchFavoriteMovies() -> Observable<[FavoriteMovie]> {
        return realm.fetch()
    }
    
    func deleteFavoriteMovie(_ movie: FavoriteMovie) -> Completable {
        return realm.delete(element: movie)
    }
}
