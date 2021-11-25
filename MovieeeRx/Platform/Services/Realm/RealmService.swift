import Foundation
import RxSwift
import RealmSwift

fileprivate enum ErrorRealm: Error {
    case errorFetch
    case errorAdd
    case errorDelete
    case errorCheck
    
    var description: String {
        switch self {
        case.errorAdd:
            return "Error Adding Item"
        case .errorFetch:
            return "Error Fetching Item"
        case .errorDelete:
            return "Error Deleting Item"
        case .errorCheck:
            return "Error Checking Item"
        }
    }
}

struct RealmService {
    static let share = RealmService()
    
    func insert(newElement: @escaping () -> Object) -> Completable {
        return Completable.create { complete in
            do {
                let realm = try Realm()
                
                try realm.write {
                    realm.add(newElement())
                    complete(.completed)
                }
            } catch {
                complete(.error(ErrorRealm.errorAdd))
            }
            
            return Disposables.create()
        }
    }
    
    func delete(element: Object? = nil, movieId: Int? = nil) -> Completable {
        return Completable.create { complete in
            do {
                let realm = try Realm()
                
                try realm.write {
                    if let element = element {
                        realm.delete(element)
                    }
                    
                    if let movieId = movieId {
                        let result = realm.objects(FavoriteMovie.self).filter("id == %i", movieId)
                        result.forEach {
                            realm.delete($0)
                        }
                    }
                    complete(.completed)
                }
            } catch {
                complete(.error(ErrorRealm.errorAdd))
            }
            
            return Disposables.create()
        }
    }
    
    func fetch<T:Object>() -> Observable<[T]> {
        return Observable.create { obs in
            do {
                let realm = try Realm()
                let result = realm.objects(T.self)
                obs.onNext(Array(result))
                obs.onCompleted()
            } catch {
                obs.onError(ErrorRealm.errorFetch)
            }
            return Disposables.create()
        }
    }
    
    func checkFavoriteMovie(movieId: Int) -> Bool {
        do {
            let realm = try Realm()
            let result = realm.objects(FavoriteMovie.self).filter("id == %i", movieId)
            if result.isEmpty {
                return false
            } else {
                return true
            }
        } catch {
            fatalError(ErrorRealm.errorCheck.description)
        }
    }
}
