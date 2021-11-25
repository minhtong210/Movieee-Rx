import Foundation
import UIKit

protocol AppNavigatorType {
    func toMain()
}

struct AppNavigator: AppNavigatorType {
    unowned let window: UIWindow!
    
    func toMain() {
        let isNewUser = UserDefaults.standard.bool(forKey: KeyUserDefaults.keyCheckNewUser)
        if isNewUser {
            let viewController = WelcomeViewController.instantiate()
            let navigator = WelcomeNavigator(window: window)
            let viewModel = WelcomeViewModel(navigator: navigator)
            viewController.bindViewModel(to: viewModel)
            window.rootViewController = viewController
        } else {
            let viewController = MainViewController.instantiate()
            let viewModel = MainViewModel()
            viewController.bindViewModel(to: viewModel)
            window.rootViewController = viewController
        }
        window.makeKeyAndVisible()
    }
    
}
