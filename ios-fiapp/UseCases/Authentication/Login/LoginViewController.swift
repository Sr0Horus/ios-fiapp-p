import UIKit

final class LoginViewController: UIViewController {
    
    // MARK: - Properties
    private let logoImageView: UIImageView = {
        let image = UIImage(named: "logo")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
                
        return imageView
    }()
    
    private lazy var emailField: UITextField = {
        let field = UITextField()
        field.placeholder = "Email".localized
        field.textColor = .label
        field.autocapitalizationType = .none
        field.keyboardType = .emailAddress
        field.autocorrectionType = .no
        field.returnKeyType = .next
        field.layer.borderWidth = 0.5
        field.layer.cornerRadius = 10
        field.leftView = UIView(frame: .init(x: 0, y: 0, width: 10, height: 45))
        field.leftViewMode = .always
        field.layer.borderColor = UIColor.gray.cgColor
        field.layer.masksToBounds = true // prevents overlay bounds
        field.translatesAutoresizingMaskIntoConstraints = false
        field.heightAnchor.constraint(equalToConstant: 45).isActive = true
        field.addTarget(self, action: #selector(textfieldDidChange(sender:)), for: .editingChanged)
        field.delegate = self
        
        return field
    }()
    
    private lazy var passwordField: UITextField = {
        let field = UITextField()
        field.placeholder = "Password".localized
        field.textColor = .label
        field.autocapitalizationType = .none
        field.returnKeyType = .done
        field.isSecureTextEntry = true
        field.layer.borderWidth = 0.5
        field.layer.cornerRadius = 10
        field.leftView = UIView(frame: .init(x: 0, y: 0, width: 10, height: 45))
        field.leftViewMode = .always
        field.layer.borderColor = UIColor.gray.cgColor
        field.layer.masksToBounds = true
        field.translatesAutoresizingMaskIntoConstraints = false
        field.heightAnchor.constraint(equalToConstant: 45).isActive = true
        field.addTarget(self, action: #selector(textfieldDidChange(sender:)), for: .editingChanged)
        field.delegate = self

        return field
    }()
    
    private let signInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("SignIn".localized, for: .normal)
        button.setTitleColor(.white, for: .normal)
        // TODO: Replace UIColor with design system.
        button.backgroundColor = AuthenticationConstants.authButtonDisabledColor
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 45).isActive = true
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(login), for: .touchUpInside)
        
        return button
    }()
    
    private let recoveryPasswordLink: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("ForgetYourPassword?".localized, for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let sigInWithGoogleButton: UIStackView = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "googleLogo")?.withRenderingMode(.alwaysOriginal)
        button.setImage(image, for: .normal)
        button.heightAnchor.constraint(equalToConstant: 35).isActive = true
        button.widthAnchor.constraint(equalToConstant: 35).isActive = true
        button.translatesAutoresizingMaskIntoConstraints = false
                
        let label = UILabel()
        label.text = "OrSignInWith".localized
        label.translatesAutoresizingMaskIntoConstraints = false
                
        let stackView = UIStackView(arrangedSubviews: [label, button])
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private let codeLegendsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("By CodeLegends", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let viewModel: LoginViewModelProtocol
    
    // MARK: - Initialization
    init(viewModel: LoginViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        syncViewModelBindings()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.removeBluerLoader()
    }
}

// MARK: - Setup UI
extension LoginViewController {
    func setupUI() {
        view.backgroundColor = .systemBackground
        setupConstraints()
        setupMissingKeyboard()
    }
    
    func setupConstraints () {
        let stackViewFields = UIStackView(arrangedSubviews: [emailField, passwordField])
        stackViewFields.axis = .vertical
        stackViewFields.spacing = 20
        stackViewFields.alignment = .fill
        stackViewFields.distribution = .fill
        stackViewFields.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackViewFields)
        NSLayoutConstraint.activate([
            stackViewFields.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackViewFields.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackViewFields.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 45),
            stackViewFields.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -45),
        ])
        
        view.addSubview(logoImageView)
        NSLayoutConstraint.activate([
            logoImageView.bottomAnchor.constraint(equalTo: stackViewFields.topAnchor, constant: -20),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 140),
            logoImageView.widthAnchor.constraint(equalToConstant: 70),
        ])
        
        view.addSubview(recoveryPasswordLink)
        NSLayoutConstraint.activate([
            recoveryPasswordLink.topAnchor.constraint(equalTo: stackViewFields.bottomAnchor, constant: 10),
            recoveryPasswordLink.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        view.addSubview(sigInWithGoogleButton)
        NSLayoutConstraint.activate([
            sigInWithGoogleButton.topAnchor.constraint(equalTo: recoveryPasswordLink.bottomAnchor, constant: 10),
            sigInWithGoogleButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        view.addSubview(signInButton)
        NSLayoutConstraint.activate([
            signInButton.topAnchor.constraint(equalTo: sigInWithGoogleButton.bottomAnchor, constant: 20),
            signInButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 45),
            signInButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -45),
        ])
                        
        view.addSubview(codeLegendsButton)
        NSLayoutConstraint.activate([
            codeLegendsButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            codeLegendsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func setupMissingKeyboard() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
}

// MARK: - Actions
extension LoginViewController {
    @objc func login() {
        view.showBlurLoader()
        
        viewModel.login { [weak self] error in
            self?.view.removeBluerLoader()
            self?.showError(message: error)
        }
    }
    
    @objc func textfieldDidChange(sender: UITextField) {
        if sender == emailField {
            viewModel.email = emailField.text
        } else {
            viewModel.password = passwordField.text
        }
    }
}

// MARK: - Sync View Model Bindings
extension LoginViewController {
    func syncViewModelBindings() {
        viewModel.validationOutputs.bind { [weak self] outputs in
            self?.signInButton.isEnabled = outputs.isValid
            self?.signInButton.backgroundColor = outputs.authButtonColor
        }
    }
}

// MARK: - Methods
extension LoginViewController {
    func showError(message: String) {
        let alertController = UIAlertController(title: "Error".localized, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK".localized, style: .default, handler: nil)
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailField:
            passwordField.becomeFirstResponder()
        case passwordField:
            login()
        default:
            return false
        }
        
        return true
    }
}
