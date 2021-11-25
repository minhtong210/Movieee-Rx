import UIKit
import RxSwift
import RxCocoa
import MGArchitecture
import Reusable
import NSObject_Rx

final class SearchViewController: UIViewController, Bindable {
    @IBOutlet private weak var notFoundView: UIView!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var searchTextField: UITextField!
    @IBOutlet private weak var searchButton: UIButton!
    @IBOutlet private weak var backButton: UIButton!
    
    var viewModel: SearchViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    func bindViewModel() {
        let input = SearchViewModel.Input(loadTrigger: Driver.just(()),
                                          searchTrigger: searchButton.rx.tap.asDriver(),
                                          searchBarReturn: searchTextField.rx.controlEvent(.editingDidEndOnExit).asDriver(),
                                          movieDetailTrigger: tableView.rx.itemSelected.asDriver(),
                                          searchText: searchTextField.rx.text.orEmpty.asDriver(),
                                          backTrigger: backButton.rx.tap.asDriver())
        let output = viewModel.transform(input, disposeBag: rx.disposeBag)
        
        output.movies
            .drive(tableView.rx.items) { tableView, index, item in
                let indexPath = IndexPath(item: index, section: 0)
                let cell: MovieInfoBriefTableViewCell = tableView.dequeueReusableCell(for: indexPath)
                
                cell.configSearchCell(from: item)
                return cell
            }
            .disposed(by: rx.disposeBag)
        
        output.isEmptyResult
            .drive(isEmptyResult)
            .disposed(by: rx.disposeBag)
        
        output.navigation
            .drive()
            .disposed(by: rx.disposeBag)
    }

    deinit {
        print("Deinit Search")
    }
    
}
//MARK: - Update UI
extension SearchViewController {
    private func configView() {
        configTableView()
        notFoundView.isHidden = true
    }
    
    private func configTableView() {
        tableView.do {
            $0.register(cellType: MovieInfoBriefTableViewCell.self)
            $0.rowHeight = $0.frame.height * 2 / 7
            $0.backgroundView = notFoundView
        }
    }
}
//MARK: - Reactive
extension SearchViewController {
    private var isEmptyResult: Binder<Bool> {
        return Binder(self) { vc, check in
            vc.notFoundView.isHidden = !check
        }
    }
}

extension SearchViewController: StoryboardSceneBased {
    static var sceneStoryboard = StoryboardName.search.storyboard
}
