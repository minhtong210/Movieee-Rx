import UIKit
import RxSwift
import RxCocoa
import MGArchitecture
import Reusable
import NSObject_Rx

final class CateGenreDetailViewController: UIViewController, Bindable {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var genreCateCollectionView: UICollectionView!
    @IBOutlet private weak var backButton: UIButton!
    
    var viewModel: CateGenreViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    func bindViewModel() {
        let input = CateGenreViewModel.Input(loadTrigger: Driver.just(()),
                                             backTrigger: backButton.rx.tap.asDriver(),
                                             movieTrigger: genreCateCollectionView.rx.itemSelected.asDriver())
        let output = viewModel.transform(input, disposeBag: rx.disposeBag)
        
        output.movies
            .drive(genreCateCollectionView.rx.items) { collectionView, index, item in
                
                let indexPath = IndexPath(item: index, section: 0)
                let cell: ImageAndNameCollectionCell = collectionView.dequeueReusableCell(for: indexPath)
                
                cell.configMovieCateGenre(from: item)
                
                return cell
            }
            .disposed(by: rx.disposeBag)
        
        output.title
            .drive(titleName)
            .disposed(by: rx.disposeBag)
        
        output.navigation
            .drive()
            .disposed(by: rx.disposeBag)
    }

    deinit {
        print("Deinit Cate Genre")
    }
}
//MARK: - Update UI
extension CateGenreDetailViewController {
    private func configView() {
        configCollectionView()
    }
    
    private func configCollectionView() {
        genreCateCollectionView.do {
            $0.register(cellType: ImageAndNameCollectionCell.self)
            $0.delegate = self
        }
    }
    
    private func updateTitle(name: String) {
        titleLabel.text = name.uppercased()
    }
}
//MARK: - Reactive
extension CateGenreDetailViewController {
    private var titleName: Binder<String> {
        return Binder(self) { vc, name in
            vc.updateTitle(name: name)
        }
    }
}
//MARK: - Collection Flow Layout
extension CateGenreDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width * 3 / 7
        let height = width * 1.8
        return CGSize(width: width, height: height)
    }
}

extension CateGenreDetailViewController: StoryboardSceneBased {
    static var sceneStoryboard = StoryboardName.cateGenre.storyboard
}
