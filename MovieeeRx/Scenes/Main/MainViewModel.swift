import Foundation
import RxSwift
import RxCocoa
import MGArchitecture

struct MainViewModelType {
}

struct MainViewModel: ViewModel {
    struct Input {
    }
    struct Output {
    }
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        return Output()
    }
}
