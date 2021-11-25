import Foundation
import RxSwift
import RxCocoa
import MGArchitecture

struct WelcomeViewModel {
    let navigator: WelcomeNavigatorType
}

extension WelcomeViewModel: ViewModel {
    struct Input {
        let getStartedButton: Driver<Void>
    }
    
    struct Output {
        let toMain: Driver<Void>
    }
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        let toMain = input.getStartedButton
            .do(onNext: {
                UserDefaults.standard.setValue(false,
                                               forKey: KeyUserDefaults.keyCheckNewUser)
                navigator.toMain()
            })
        
        return Output(toMain: toMain)
    }
}
