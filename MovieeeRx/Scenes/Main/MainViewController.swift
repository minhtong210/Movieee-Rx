import UIKit
import Foundation
import RxCocoa
import RxSwift
import MGArchitecture
import NSObject_Rx
import Reusable

fileprivate enum TabItem: String {
    case home = "Home"
    case category = "Category"
    case favorite = "Favorite"
    
    var image: UIImage? {
        switch self {
        case .home:
            return UIImage(systemName: "house")
        case .category:
            return UIImage(systemName: "film")
        case .favorite:
            return UIImage(systemName: "suit.heart")
        }
    }
}

fileprivate enum Constaints {
    static let tabbarTintColor = "AppBackgroundColor"
}

final class MainViewController: UITabBarController, Bindable {
    
    var viewModel: MainViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    func bindViewModel() {
        let input = MainViewModel.Input()
        let _ = viewModel.transform(input, disposeBag: rx.disposeBag)
    }
    
    deinit {
        print("Deinit Main")
    }
}

extension MainViewController {
    private func configView() {
        configTabbar()
        initHome()
        initCategory()
        initFavorite()
    }
    
    private func configTabbar() {
        tabBar.do {
            $0.barTintColor = UIColor(named: Constaints.tabbarTintColor)
            $0.tintColor = .white
        }
        
    }
    
    private func initHome() {
        let viewController = HomeViewController.instantiate()
        let homeTab = UINavigationController(rootViewController: viewController)
            .then {
                $0.tabBarItem = UITabBarItem(title: TabItem.home.rawValue,
                                             image: TabItem.home.image,
                                             selectedImage: nil)
                $0.navigationBar.isHidden = true
            }
        let usecase = HomeUseCase()
        let navigator = HomeNavigator(navigationController: homeTab)
        let viewModel = HomeViewModel(navigator: navigator,
                                      useCase: usecase)
        viewController.bindViewModel(to: viewModel)
        
        viewControllers = [homeTab]
    }
    
    private func initCategory() {
        let viewController = CategoryViewController.instantiate()
        let categoryTab = UINavigationController(rootViewController: viewController)
            .then {
                $0.tabBarItem = UITabBarItem(title: TabItem.category.rawValue,
                                             image: TabItem.category.image,
                                             selectedImage: nil)
                $0.navigationBar.isHidden = true
            }
        let navigator = CategoryNavigator(navigationController: categoryTab)
        let useCase = CategoryUseCase()
        let viewModel = CategoryViewModel(navigator: navigator,
                                          useCase: useCase)
        viewController.bindViewModel(to: viewModel)
        
        viewControllers?.append(categoryTab)
    }
    
    private func initFavorite() {
        let viewController = FavoriteViewController.instantiate()
        let favoriteTab = UINavigationController(rootViewController: viewController)
            .then {
                $0.tabBarItem = UITabBarItem(title: TabItem.favorite.rawValue,
                                             image: TabItem.favorite.image,
                                             selectedImage: nil)
                $0.navigationBar.isHidden = true
            }
        let navigator = FavoriteNavigator(navigationController: favoriteTab)
        let useCase = FavoriteUseCase()
        let viewModel = FavoriteViewModel(navigator: navigator,
                                          useCase: useCase)
        viewController.bindViewModel(to: viewModel)
        
        viewControllers?.append(favoriteTab)
    }
}

extension MainViewController: StoryboardSceneBased {
    static var sceneStoryboard = StoryboardName.main.storyboard
}
