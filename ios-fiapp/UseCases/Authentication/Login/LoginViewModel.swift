import UIKit.UIColor

struct UserValidationOutput {
    let isValid: Bool
    let authButtonColor: UIColor
}

protocol LoginViewModelProtocol: AnyObject {
    func login(onError: @escaping (String) -> Void)
    var email: String? { get set }
    var password: String? { get set }
    var validationOutputs: Box<UserValidationOutput> { get }
}

class LoginViewModel {
    
    // MARK: - Constants
    enum LoginValidationConstants {
        static let minEmailLength = 4
        static let minPasswordLength = 4
    }
    
    // MARK: - Properties
    private var authService: AuthenticationProvidable?
    private let router: LoginRouterProtocol
    
    var email: String? = "" {
        didSet {
            validateUser()
        }
    }
    var password: String? = "" {
        didSet {
            validateUser()
        }
    }
    
    var validationOutputs = Box(
        UserValidationOutput(
            isValid: false,
            authButtonColor: AuthenticationConstants.authButtonDisabledColor
        )
    )
    
    // MARK: - Initialization
    init(authService: AuthenticationProvidable, router: LoginRouterProtocol) {
        self.authService = authService
        self.router = router
    }
}

// MARK: - LoginViewModelProtocol
extension LoginViewModel: LoginViewModelProtocol {
    private func validateUser() {
        guard
            let email = email,
            let password = password,
            !email.isEmpty,
            !password.isEmpty,
            email.count >= LoginValidationConstants.minEmailLength,
            password.count >= LoginValidationConstants.minPasswordLength,
            email.isValidEmail
        else  {
            validationOutputs.value = .init(
                isValid: false,
                authButtonColor: AuthenticationConstants.authButtonDisabledColor
            )
            return
        }
        
        validationOutputs.value = UserValidationOutput(
            isValid: true,
            authButtonColor: AuthenticationConstants.authButtonEnabledColor
        )
    }
    
    func login(onError: @escaping (String) -> Void) {
        guard let email = email,
              let password = password
        else {
            onError("ShouldAddCredentials".localized)
            return
        }
        
        authService?.loginUser(withEmail: email, andPassword: password, completion: { [weak self] error, user in
            guard let self = self else { return }
            
            if error != nil {
                onError("WrongCredentials".localized)
                return
            }
            
            print("¡Logueado exitosamente!")
            self.router.navigateToMainScreen()
        })
    }
}
