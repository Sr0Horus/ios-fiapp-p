import UIKit

protocol LoginRouterProtocol {
    func navigateToMainScreen()
}

final class LoginRouter {
    
    // MARK: - Properties
    var view: UIViewController?
    
    // MARK: - Build View
    static func view() -> UINavigationController {
        
        let router = LoginRouter()
        let authService = AuthenticationProviderFB()
        let loginViewModel = LoginViewModel(authService: authService, router: router)
        
        let loginViewController = LoginViewController(viewModel: loginViewModel)
        router.view = loginViewController
        let navigation = UINavigationController(rootViewController: loginViewController)
        navigation.navigationBar.isHidden = true
        return navigation
    }
}

// MARK: - LoginRouterProtocol
extension LoginRouter: LoginRouterProtocol {
    func navigateToMainScreen() {
        view?.navigationController?.pushViewController(MainTabBarController(), animated: true)
    }
}
