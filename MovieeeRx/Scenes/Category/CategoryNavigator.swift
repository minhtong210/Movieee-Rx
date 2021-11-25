import UIKit

protocol CategoryNavigatorType {
    func toCateGenreDetail(category: CategoryType)
    func toSearch()
}

struct CategoryNavigator: CategoryNavigatorType {
    unowned let navigationController: UINavigationController
    
    func toCateGenreDetail(category: CategoryType) {
        let viewController = CateGenreDetailViewController.instantiate()
        let useCase = CateGenreUseCase()
        let navigator = CateGenreNavigator(navigationController: navigationController)
        let viewModel = CateGenreViewModel(navigator: navigator,
                                           useCase: useCase,
                                           category: category,
                                           genre: nil)
        viewController.bindViewModel(to: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func toSearch() {
        let viewController = SearchViewController.instantiate()
        let useCase = SearchUseCase()
        let navigator = SearchNavigator(navigationController: navigationController)
        let viewModel = SearchViewModel(navigator: navigator,
                                        useCase: useCase)
        viewController.bindViewModel(to: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
}
