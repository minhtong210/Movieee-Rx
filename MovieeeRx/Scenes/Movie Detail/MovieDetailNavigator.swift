import UIKit

protocol MovieDetailNavigatorType {
    func toCateGenreDetail(genre: Genre)
    func toPersonDetail(personId: Int)
    func toTrailer(movieId: Int)
    func toBackView()
}

struct MovieDetailNavigator: MovieDetailNavigatorType {
    unowned let navigationController: UINavigationController
    
    func toPersonDetail(personId: Int) {
        let viewController = PersonDetailViewController.instantiate()
        let useCase = PersonDetailUseCase()
        let navigator = PersonDetailNavigator(navigationController: navigationController)
        let viewModel = PersonDetailViewModel(navigator: navigator,
                                              useCase: useCase,
                                              personId: personId)
        viewController.bindViewModel(to: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func toTrailer(movieId: Int) {
        let viewController = TrailerViewController.instantiate()
        let useCase = TrailerUseCase()
        let navigator = TrailerNavigator(navigationController: navigationController)
        let viewModel = TrailerViewModel(navigator: navigator,
                                         useCase: useCase,
                                         movieId: movieId)
        viewController.bindViewModel(to: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func toCateGenreDetail(genre: Genre) {
        let viewController = CateGenreDetailViewController.instantiate()
        let useCase = CateGenreUseCase()
        let navigator = CateGenreNavigator(navigationController: navigationController)
        let viewModel = CateGenreViewModel(navigator: navigator,
                                           useCase: useCase,
                                           category: nil,
                                           genre: genre)
        viewController.bindViewModel(to: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func toBackView() {
        navigationController.popViewController(animated: true)
    }
    
}
