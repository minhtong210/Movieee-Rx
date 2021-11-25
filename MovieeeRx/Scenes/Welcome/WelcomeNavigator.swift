import Foundation
import UIKit

protocol WelcomeNavigatorType {
    func toMain()
}

struct WelcomeNavigator: WelcomeNavigatorType {
    unowned let window: UIWindow
    
    func toMain() {
        let viewController = MainViewController.instantiate()
        let viewModel = MainViewModel()
        viewController.bindViewModel(to: viewModel)
        
        window.rootViewController = viewController
        window.makeKeyAndVisible()
    }
}
