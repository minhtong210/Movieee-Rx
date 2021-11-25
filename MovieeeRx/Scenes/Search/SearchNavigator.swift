import UIKit

protocol SearchNavigatorType {
    func toMovieDetail(movieId: Int)
    func toBackView()
}

struct SearchNavigator: SearchNavigatorType {
    unowned let navigationController: UINavigationController
    
    func toBackView() {
        navigationController.popViewController(animated: true)
    }
    
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
}
