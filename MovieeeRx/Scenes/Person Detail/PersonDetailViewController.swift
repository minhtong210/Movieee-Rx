import UIKit
import RxSwift
import RxCocoa
import Then
import MGArchitecture
import Reusable
import NSObject_Rx
import ESPullToRefresh
import SDWebImage

final class PersonDetailViewController: UIViewController, Bindable {
    @IBOutlet private weak var castImageView: UIImageView!
    @IBOutlet private weak var castNameLabel: UILabel!
    @IBOutlet private weak var castDepartmentLabel: UILabel!
    @IBOutlet private weak var castGenderLabel: UILabel!
    @IBOutlet private weak var castBirthLabel: UILabel!
    @IBOutlet private weak var castBiographyLabel: UILabel!
    @IBOutlet private weak var knownForCollectionView: UICollectionView!
    @IBOutlet private weak var backButton: UIButton!
    
    var viewModel: PersonDetailViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    func bindViewModel() {
        let input = PersonDetailViewModel.Input(loadTrigger: Driver.just(()),
                                                backTrigger: backButton.rx.tap.asDriver(),
                                                knownForTrigger: knownForCollectionView.rx.itemSelected.asDriver())
        let output = viewModel.transform(input, disposeBag: rx.disposeBag)
        
        output.personKnownFor
            .drive(knownForCollectionView.rx.items) { collectionView, index, item in
                let indexPath = IndexPath(item: index, section: 0)
                let cell: ImageAndNameCollectionCell = collectionView.dequeueReusableCell(for: indexPath)
                
                cell.configMovieCellPersonDetail(from: item)
                
                return cell
            }
            .disposed(by: rx.disposeBag)
        
        output.personDetail
            .drive(movieDetail)
            .disposed(by: rx.disposeBag)
        
        output.toMovieDetail
            .drive()
            .disposed(by: rx.disposeBag)
        
        output.toBackView
            .drive()
            .disposed(by: rx.disposeBag)
    }
    
    deinit {
        print("Deinit Person Detail")
    }
}
//MARK: - Configure View
extension PersonDetailViewController {
    private func configView() {
        configCollection()
    }
    
    private func configCollection() {
        knownForCollectionView.do {
            $0.register(cellType: ImageAndNameCollectionCell.self)
            $0.delegate = self
        }
    }
    
    private func updateView(from person: PersonDetail) {
        castImageView.sd_setImage(with: URL(string: URLs.Image.person + person.image),
                                  completed: nil)
        castNameLabel.text = person.name
        castDepartmentLabel.text = person.department
        castGenderLabel.text = person.gender.kind
        castBirthLabel.text = person.birthday
        castBiographyLabel.text = person.biography
    }
}

//MARK: - Reactive
extension PersonDetailViewController {
    private var movieDetail: Binder<PersonDetail> {
        return Binder(self) { vc, personDetail in
            vc.updateView(from: personDetail)
        }
    }
}

extension PersonDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.height / 2
        let height = collectionView.frame.height
        return CGSize(width: width, height: height)
    }
}

extension PersonDetailViewController: StoryboardSceneBased {
    static var sceneStoryboard = StoryboardName.personDetail.storyboard
}
