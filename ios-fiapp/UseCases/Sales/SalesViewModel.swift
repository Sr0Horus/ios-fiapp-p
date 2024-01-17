import UIKit

class SalesViewModel {
    var view: SalesViewController?
    private let router: SalesRouterProtocol
    
    // MARK: - Initialization
    init(router: SalesRouterProtocol) {
        self.router = router
    }
}
