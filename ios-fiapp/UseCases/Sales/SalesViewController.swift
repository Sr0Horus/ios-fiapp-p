import UIKit
import Firebase

class SalesViewController: UIViewController {
    
    // MARK: - properties
    let viewModel: SalesViewModel
        
    // MARK: - constructor
    init(viewModel: SalesViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Methods
    func setupUI(){
        view.backgroundColor = .red
        
        self.navigationController?.navigationItem.backBarButtonItem?.isEnabled = false;
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(logout))
    }
    
    // MARK: - Actions
    @objc func logout(){
        try! Auth.auth().signOut()
        
        UIView.transition(with: self.window!, duration: 0.5, options: UIView.AnimationOptions.transitionFlipFromLeft, animations: {
          self.window?.rootViewController = LoginRouter.view()
        }, completion: nil)
    }
}
