//
//  LoginViewController.swift
//  MoneyBox
//
//  Created by Zeynep Kara on 16.01.2022.
//

import UIKit
import Networking

class LoginViewController: UIViewController {
    
    // MARK: - Properties
    
    private struct Constants {
        static let horizontalPadding: CGFloat = 16
    }
    
    private lazy var logoImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "moneybox")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isAccessibilityElement = true
        imageView.accessibilityTraits = .image
        imageView.accessibilityLabel = "MoneyBox Logo"
        return imageView
    }()
    
    private lazy var emailField: LoginTextField = {
        let view = LoginTextField()
        view.configure(title: "Email address", tag: 0)
        view.delegate = viewModel
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var passwordField: LoginTextField = {
        let view = LoginTextField()
        view.configure(title: "Password", isSecure: true, tag: 1)
        view.delegate = viewModel
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.addArrangedSubview(emailField)
        stackView.addArrangedSubview(passwordField)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var loginButton: LoadingButton = {
        let button = LoadingButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(login), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Initialization
    
    private let viewModel: LoginViewModelProtocol
    
    init(viewModel: LoginViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupView()
        handleLoginErrors()
        handleSuccessfulLogin()
        viewModel.delegate = self
    }
    
    // MARK: - Action
    
    @objc private func login() {
        resetErrors()
        loginButton.showLoading()
        
        viewModel.login(email: emailField.text, password: passwordField.text)
        //viewModel.login(email: "test+ios@moneyboxapp.com", password: "P455word12")
    }
    
    private func handleSuccessfulLogin() {
        viewModel.didSuccessfullyLogin = { [weak self] user in
            self?.loginButton.hideLoading()
            self?.navigateToAccounts(user: user)
        }
    }
    
    private func handleLoginErrors() {
        viewModel.onLoginError = { [weak self] error in
            self?.loginButton.hideLoading()
            switch error.loginError {
            case .emailError:
                self?.emailField.showError(error: error.emailError)
            case .passwordError:
                self?.passwordField.showError(error: error.passwordError)
            case .unknownError:
                self?.showErrorAlert(error: error)
            }
        }
    }
    
    private func showErrorAlert(error: ErrorResponse) {
        let alert = UIAlertController(title: error.name, message: error.message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
        
    private func navigateToAccounts(user: LoginResponse.User) {
        navigationController?.setViewControllers([
            AccountsViewController(
                viewModel: AccountsViewModel(user: user),
                accountsCompositionalController: AccountsCompositionalController()
            )
        ], animated: true
        )
    }
    
    // MARK: - Setup
    
    private func setupView() {
        view.addSubview(logoImage)
        view.addSubview(stackView)
        view.addSubview(loginButton)
        
        NSLayoutConstraint.activate([
            
            logoImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            //logoImage.heightAnchor.constraint(equalToConstant: 80),
            logoImage.widthAnchor.constraint(equalToConstant: 150),
            logoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            stackView.topAnchor.constraint(equalTo: logoImage.bottomAnchor, constant: 40),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.horizontalPadding),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.horizontalPadding),
            
            loginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            loginButton.heightAnchor.constraint(equalToConstant: 44),
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.horizontalPadding),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.horizontalPadding)
        ])
    }
}

extension LoginViewController: LoginViewModelDelegate {
    
    func loginTextFieldDidBeginEditing(_ textField: UITextField) {
        resetErrors()
    }
    
    private func resetErrors() {
        emailField.reset()
        passwordField.reset()
    }
}
