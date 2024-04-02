import UIKit
import Networking

protocol LoginViewModelProtocol: AnyObject, LoginTextFieldDelegate {
    func login(email: String?, password: String?)
    var didSuccessfullyLogin: ((LoginResponse.User) -> Void)? { get set }
    var onLoginError: ((ErrorResponse) -> Void)? { get set }
    var dataProvider: DataProviderProtocol { get }
    var sessionManager: SessionManagerProtocol { get }
}

final class LoginViewModel: LoginViewModelProtocol, LoginTextFieldDelegate {
    
    var dataProvider: DataProviderProtocol
    var sessionManager: SessionManagerProtocol
    
    var didSuccessfullyLogin: ((LoginResponse.User) -> Void)?
    var onLoginError: ((ErrorResponse) -> Void)?

    init(dataProvider: DataProviderProtocol,
         sessionManager: SessionManagerProtocol
    ) {
        self.dataProvider = dataProvider
        self.sessionManager = sessionManager
    }
    
    func login(email: String?, password: String?) {
        guard
            let email = email,
            let password = password
        else { return }
        
        let loginRequest = LoginRequest(email: email, password: password)
        
        dataProvider.login(request: loginRequest) { [weak self] result in
            switch result {
            case .success(let success):
                print(success)
                self?.sessionManager.setUserToken(success.session.bearerToken)
                self?.didSuccessfullyLogin?(success.user)
            case .failure(let error):
                self?.onLoginError?(error)
            }
        }
    }
    
    func assignSessionToken(token: String) {
        sessionManager.setUserToken(token)
    }
    
    func loginTextFieldDidReturn(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    func loginTextFieldDidChange(_ textField: UITextField) {
        print(textField.text)
    }
}
