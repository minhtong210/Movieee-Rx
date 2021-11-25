import RxSwift
import RxCocoa

protocol CategoryUseCaseType {
    func getCategoryTitle() -> Observable<[CategoryType]>
}

struct CategoryUseCase: CategoryUseCaseType {
    func getCategoryTitle() -> Observable<[CategoryType]> {
        return Observable.create { obs in
            let allCategory: [CategoryType] = [.nowPlaying,.popular,.upcoming,.topRated]
            obs.onNext(allCategory)
            obs.onCompleted()
            return Disposables.create()
        }
    }
}
