import UIKit
import RxSwift
import RxCocoa
import Then
import MGArchitecture
import Reusable
import NSObject_Rx
import ESPullToRefresh

fileprivate enum Constraints {
    static let heightForRowTableView: CGFloat = 340
}

final class HomeViewController: UIViewController, Bindable {
    //MARK: - Variables
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var searchButton: UIButton!
    
    private var listCell = [HomeCellType]()
    private var storedOffsets = [Int: CGFloat]()
    
    //MARK: - ViewModel
    var viewModel: HomeViewModel!
    private let movieDetailTrigger = PublishSubject<Movie>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    func bindViewModel() {
        let input = HomeViewModel.Input(loadTrigger: Driver.just(()),
                                        searchTrigger: searchButton.rx.tap.asDriver(),
                                        movieDetailTrigger: movieDetailTrigger.asDriverOnErrorJustComplete())
        let output = viewModel.transform(input, disposeBag: rx.disposeBag)
        
        output.items
            .drive(tableView.rx.items) { [weak self] tableView, index, item in
                self?.listCell.append(item)
                
                let indexPath = IndexPath(item: index, section: 0)
                let cell: HomeTableViewCell = tableView.dequeueReusableCell(for: indexPath)
                
                cell.configCell(category: item)
                return cell
            }
            .disposed(by: rx.disposeBag)
        
        output.navigation
            .drive()
            .disposed(by: rx.disposeBag)
    }
    
    deinit {
        print("Deinit Home")
    }
}

//MARK: - ConfigView
extension HomeViewController {
    private func configView() {
        configTableView()
    }
    
    private func configTableView() {
        tableView.do {
            $0.register(cellType: HomeTableViewCell.self)
            $0.separatorStyle = .none
            $0.delegate = self
            $0.rowHeight = Constraints.heightForRowTableView
        }
    }
}
//MARK: - TableView
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        guard let tableViewCell = cell as? HomeTableViewCell else { return }
        tableViewCell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self,
                                                          forRow: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView,
                   didEndDisplaying cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        guard let tableViewCell = cell as? HomeTableViewCell else { return }
        storedOffsets[indexPath.row] = tableViewCell.collectionViewOffset
    }
}

//MARK: - CollectionView Datasource
extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return listCell[collectionView.tag].movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ImageAndNameCollectionCell = collectionView.dequeueReusableCell(for: indexPath)
        
        cell.configMovieCellHome(from: listCell[collectionView.tag].movies[indexPath.row])
        
        return cell
    }
}
//MARK: - CollectionView Delegate
extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        let movie = listCell[collectionView.tag].movies[indexPath.row]
        movieDetailTrigger.onNext(movie)
    }
}

extension HomeViewController: StoryboardSceneBased {
    static var sceneStoryboard = StoryboardName.home.storyboard
}
