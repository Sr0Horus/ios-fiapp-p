import UIKit

final class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewControllers()
        tabBar.isTranslucent = false
        tabBar.barTintColor = UIColor(red: 37 / 255, green: 71 / 255, blue: 65 / 255, alpha: 1)//UIColor(hex: "#254741")
        tabBar.tintColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationItem.backBarButtonItem?.isEnabled = false
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    func configureViewControllers(){
        let sales = SalesRouter.view()
        let navSales = templateNavigationController(image: UIImage(named: "sales"), title: "Sales".localized, rootViewController: sales)
        viewControllers = [navSales]
    }
    
    func templateNavigationController(image: UIImage?,title: String?, rootViewController: UIViewController) ->
    UINavigationController
    {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.title = title
        nav.tabBarItem.image = image
        
        return nav
    }
}
