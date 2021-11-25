import UIKit

protocol FavoriteNavigatorType {
    func toMovieDetail(movieId: Int)
    func toSearch()
}

struct FavoriteNavigator: FavoriteNavigatorType {
    unowned let navigationController: UINavigationController
    
    func toMovieDetail(movieId: Int) {
        let viewController = MovieDetailViewController.instantiate()
        let useCase = MovieDetailUseCase()
        let navigator = MovieDetailNavigator(navigationController: navigationController)
        let viewModel = MovieDetailViewModel(navigator: navigator,
                                             useCase: useCase,
                                             movieId: movieId)
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
