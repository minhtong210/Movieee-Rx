import RxSwift
import RxCocoa
import MGArchitecture

struct CategoryViewModel {
    let navigator: CategoryNavigatorType
    let useCase: CategoryUseCaseType
}

extension CategoryViewModel: ViewModel {
    
    struct Input {
        let loadTrigger: Driver<Void>
        let searchTrigger: Driver<Void>
        let cellTrigger: Driver<IndexPath>
    }
    
    struct Output {
        let categories: Driver<[CategoryType]>
        let navigation: Driver<Void>
    }
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        
        let categories = input.loadTrigger
            .flatMapLatest { _ in
                useCase.getCategoryTitle()
                    .asDriverOnErrorJustComplete()
            }
        
        let toSearch = input.searchTrigger
            .do(onNext: {
                navigator.toSearch()
            })
        
        let toCateGenreDetail = input.cellTrigger
            .withLatestFrom(categories) {
                navigator.toCateGenreDetail(category: $1[$0.row] )
            }
            .asDriver()
        
        let navigation = Driver.merge(toCateGenreDetail, toSearch)
        
        return Output(categories: categories,
                      navigation: navigation)
    }
}
