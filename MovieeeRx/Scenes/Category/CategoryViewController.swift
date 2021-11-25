import UIKit
import RxSwift
import RxCocoa
import Then
import MGArchitecture
import Reusable
import NSObject_Rx
import ESPullToRefresh

final class CategoryViewController: UIViewController, Bindable {
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var searchButton: UIButton!
    
    var viewModel: CategoryViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    func bindViewModel() {
        let input = CategoryViewModel.Input(loadTrigger: Driver.just(()),
                                            searchTrigger: searchButton.rx.tap.asDriver(),
                                            cellTrigger: tableView.rx.itemSelected.asDriverOnErrorJustComplete())
        let output = viewModel.transform(input, disposeBag: rx.disposeBag)
        
        output.categories
            .drive(tableView.rx.items) { tableView, index, item in
                let indexPath = IndexPath(item: index, section: 0)
                let cell: CategoryTableCell = tableView.dequeueReusableCell(for: indexPath)
                
                cell.configCell(category: item)
                
                return cell
            }
            .disposed(by: rx.disposeBag)
        
        output.navigation
            .drive()
            .disposed(by: rx.disposeBag)
    }
    
    deinit {
        print("Deinit Category")
    }
}

extension CategoryViewController {
    private func configView() {
        configTableView()
    }
    
    private func configTableView() {
        tableView.do {
            $0.register(cellType: CategoryTableCell.self)
            $0.isScrollEnabled = false
            $0.rowHeight = $0.frame.width * 3 / 7
        }
    }
}

extension CategoryViewController: StoryboardSceneBased {
    static var sceneStoryboard = StoryboardName.category.storyboard
}
