import UIKit
import RxSwift
import RxCocoa
import MGArchitecture
import Reusable
import NSObject_Rx
import WebKit

final class TrailerViewController: UIViewController, Bindable {
    @IBOutlet private weak var videoUtubeWebView: WKWebView!
    @IBOutlet private weak var backButton: UIButton!
    
    var viewModel: TrailerViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func bindViewModel() {
        let input = TrailerViewModel.Input(loadTrigger: Driver.just(()),
                                           backTrigger: backButton.rx.tap.asDriver())
        let output = viewModel.transform(input, disposeBag: rx.disposeBag)
        
        output.trailerKey
            .drive(trailerKey)
            .disposed(by: rx.disposeBag)
        
        output.toBackView
            .drive()
            .disposed(by: rx.disposeBag)
    }

    deinit {
        print("Deinit Trailer")
    }
    
}
//MARK: - Update UI
extension TrailerViewController {
    private func playUtubeVideo(from key: String) {
        guard let url = URL(string: URLs.videoUtube + key)
        else { return }
        let request = URLRequest(url: url)
        videoUtubeWebView.load(request)
    }
}

//MARK: - Reactive
extension TrailerViewController {
    private var trailerKey: Binder<String> {
        return Binder(self) { vc, trailerKey in
            vc.playUtubeVideo(from: trailerKey)
        }
    }
}

extension TrailerViewController: StoryboardSceneBased {
    static var sceneStoryboard = StoryboardName.trailer.storyboard
}
