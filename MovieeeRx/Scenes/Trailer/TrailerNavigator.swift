import UIKit

protocol TrailerNavigatorType {
    func toBackView()
}

struct TrailerNavigator: TrailerNavigatorType {
    unowned let navigationController: UINavigationController
    
    func toBackView() {
        navigationController.popViewController(animated: true)
    }
}
