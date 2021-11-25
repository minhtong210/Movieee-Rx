import UIKit
import Foundation
import RxCocoa
import RxSwift
import MGArchitecture
import NSObject_Rx
import Reusable

final class WelcomeViewController: UIViewController, Bindable {
    @IBOutlet weak var getStartedButton: UIButton!
    
    var viewModel: WelcomeViewModel!
    
    func bindViewModel() {
        let input = WelcomeViewModel.Input(getStartedButton: getStartedButton.rx.tap.asDriver())
        let output = viewModel.transform(input, disposeBag: rx.disposeBag)
        
        output.toMain
            .drive()
            .disposed(by: rx.disposeBag)
    }
}

extension WelcomeViewController: StoryboardSceneBased {
    static var sceneStoryboard = StoryboardName.welcome.storyboard
}
