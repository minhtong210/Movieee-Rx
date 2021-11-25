import UIKit
import RxSwift
import RxCocoa
import Then
import MGArchitecture
import Reusable
import NSObject_Rx

fileprivate enum Constraints {
    static let trashIcon = (name: "trash", size: CGFloat(40),
                            backgroundColor: "AppBackgroundColor")
}

final class FavoriteViewController: UIViewController, Bindable {
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var searchButton: UIButton!
    
    var viewModel: FavoriteViewModel!
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
        let input = FavoriteViewModel.Input(loadTrigger: Driver.just(()),
                                            searchTrigger: searchButton.rx.tap.asDriver(),
                                            movieDetailTrigger: tableView.rx.itemSelected.asDriver(),
                                            deleteTrigger: tableView.rx.modelDeleted(FavoriteMovie.self).asDriver(),
                                            notification: notification.asDriverOnErrorJustComplete())
        let output = viewModel.transform(input, disposeBag: rx.disposeBag)
        
        output.items
            .drive(tableView.rx.items) { tableView, index, item in
                let indexPath = IndexPath(item: index, section: 0)
                let cell: MovieInfoBriefTableViewCell = tableView.dequeueReusableCell(for: indexPath)
                
                cell.configFavoriteCell(from: item)
                
                return cell
            }
            .disposed(by: rx.disposeBag)
        
        output.navigation
            .drive()
            .disposed(by: rx.disposeBag)
    }
}
//MARK: - Update UI
extension FavoriteViewController {
    private func configView() {
        configTableView()
    }
    
    private func configTableView() {
        tableView.do {
            $0.register(cellType: MovieInfoBriefTableViewCell.self)
            $0.delegate = self
            $0.rowHeight = $0.frame.height * 4 / 15
        }
    }
}

//MARK: - TableView Delegate
extension FavoriteViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteButton = UIContextualAction(style: .normal, title: "") { _, _, completion in
            tableView.dataSource?.tableView?(tableView, commit: .delete, forRowAt: indexPath)
            completion(true)
        }.then {
            $0.backgroundColor = UIColor(named: Constraints.trashIcon.backgroundColor)
            $0.image = UIImage(systemName: Constraints.trashIcon.name,
                               withConfiguration: UIImage.SymbolConfiguration(pointSize: Constraints.trashIcon.size))
        }
        return UISwipeActionsConfiguration(actions: [deleteButton])
    }
}

extension FavoriteViewController: StoryboardSceneBased {
    static var sceneStoryboard = StoryboardName.favorite.storyboard
}
