import UIKit
import RxSwift
import RxCocoa
import Then
import MGArchitecture
import Reusable
import NSObject_Rx
import ESPullToRefresh
import SDWebImage
import Cosmos

fileprivate enum Constraints {
    static let loveBackgroundColor = "LoveBackgroundColor"
}

final class MovieDetailViewController: UIViewController, Bindable {
    //MARK: Variables
    @IBOutlet private weak var favoriteButton: UIButton!
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var trailerButton: UIButton!
    @IBOutlet private weak var posterImage: UIImageView!
    @IBOutlet private weak var filmNameLabel: UILabel!
    @IBOutlet private weak var filmDuration: UILabel!
    @IBOutlet private weak var filmReleaseDay: UILabel!
    @IBOutlet private weak var filmDescription: UILabel!
    @IBOutlet private weak var voteRate: UILabel!
    @IBOutlet private weak var genreCollection: UICollectionView!
    @IBOutlet private weak var castCollection: UICollectionView!
    @IBOutlet private weak var ratingStars: CosmosView!
    
    //MARK: - ViewModel
    var viewModel: MovieDetailViewModel!
    private var notification = PublishSubject<Int>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        notification.onNext(1)
    }
    
    func bindViewModel() {
        let input = MovieDetailViewModel.Input(loadTrigger: Driver.just(()),
                                               backTrigger: backButton.rx.tap.asDriver(),
                                               favoriteTrigger: favoriteButton.rx.tap.asDriver(),
                                               trailerTrigger: trailerButton.rx.tap.asDriver(), personTrigger: castCollection.rx.itemSelected.asDriver(),
                                               genreTrigger: genreCollection.rx.itemSelected.asDriver(),
                                               notification: notification.asDriverOnErrorJustComplete())
        let output = viewModel.transform(input, disposeBag: rx.disposeBag)
        
        output.movieDetail
            .drive(movieDetail)
            .disposed(by: rx.disposeBag)
        
        output.movieGenres
            .drive(genreCollection.rx.items) { collectionView, index, item in
                let indexPath = IndexPath(item: index, section: 0)
                let cell: GenreCollectionCell = collectionView.dequeueReusableCell(for: indexPath)
                
                cell.configCell(from: item)
                
                return cell
            }
            .disposed(by: rx.disposeBag)
        
        output.movieCast
            .drive(castCollection.rx.items) { collectionView, index, item in
                let indexPath = IndexPath(item: index, section: 0)
                let cell: ImageAndNameCollectionCell = collectionView.dequeueReusableCell(for: indexPath)
                
                cell.configPersonCellMovieDetail(from: item)
                
                return cell
            }
            .disposed(by: rx.disposeBag)
        
        output.favoriteTrigger
            .drive(favoriteButtonCheck)
            .disposed(by: rx.disposeBag)
        
        output.notification
            .drive(favoriteButtonCheck)
            .disposed(by: rx.disposeBag)
        
        output.navigation
            .drive()
            .disposed(by: rx.disposeBag)
    }
    
    deinit {
        print("Deinit Movie Detail")
    }
}
//MARK: - Configure View
extension MovieDetailViewController {
    private func configView() {
        configCollection()
    }
    
    private func configCollection() {
        castCollection.do {
            $0.register(cellType: ImageAndNameCollectionCell.self)
            $0.delegate = self
        }
        genreCollection.do {
            $0.register(cellType: GenreCollectionCell.self)
            $0.delegate = self
        }
    }
    
    private func updateView(from movie: MovieDetail) {
        posterImage.sd_setImage(with: URL(string: URLs.Image.movie + movie.poster),
                                completed: nil)
        filmNameLabel.text = movie.title
        filmDuration.text = "\(movie.runtime / 60)h \(movie.runtime % 60)m"
        filmDescription.text = movie.overview
        filmReleaseDay.text = movie.releaseDay
        ratingStars.rating = movie.voteAverage / 2
        voteRate.text = String(movie.voteAverage)
    }
}

//MARK: - Reactive
extension MovieDetailViewController {
    private var movieDetail: Binder<MovieDetail> {
        return Binder(self) { vc, movieDetail in
            vc.updateView(from: movieDetail)
        }
    }
    
    private var favoriteButtonCheck: Binder<Bool> {
        return Binder(self) { vc, check in
            let image = check ?
                UIColor.systemPink :
                UIColor(named: Constraints.loveBackgroundColor)
            vc.favoriteButton.backgroundColor = image
        }
    }
}

//MARK: - CollectionView Delegate
extension MovieDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == castCollection {
            let width = collectionView.frame.height / 2
            let height = collectionView.frame.height
            return CGSize(width: width, height: height)
        }
        let width = collectionView.frame.height * 4 / 3
        let height = collectionView.frame.height / 3
        return CGSize(width: width, height: height)
    }
}

extension MovieDetailViewController: StoryboardSceneBased {
    static var sceneStoryboard = StoryboardName.movieDetail.storyboard
}
