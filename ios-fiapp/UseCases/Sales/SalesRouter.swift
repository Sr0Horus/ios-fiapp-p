import UIKit

protocol SalesRouterProtocol {}

final class SalesRouter {
    
    // MARK: - properties
    var view: UIViewController?
    
    // MARK: - Build view
    static func view() -> UIViewController {
        let router = SalesRouter()
        let salesViewModel = SalesViewModel(router: router)
        let salesViewController = SalesViewController(viewModel: salesViewModel)
        
        return salesViewController
    }
}

// MARK: - MainRouterProtocol
extension SalesRouter: SalesRouterProtocol {}
