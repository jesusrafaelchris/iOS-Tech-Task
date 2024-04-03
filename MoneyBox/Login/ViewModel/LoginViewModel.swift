import UIKit
import Networking

public protocol LoginViewModelDelegate: AnyObject {
    func loginTextFieldDidBeginEditing(_ textField: UITextField)
}

public protocol LoginViewModelProtocol: LoginTextFieldDelegate {
    func login(email: String, password: String)
    var didSuccessfullyLogin: ((LoginResponse.User) -> Void)? { get set }
    var onLoginError: ((ErrorResponse) -> Void)? { get set }
    var dataProvider: DataProviderProtocol { get }
    var sessionManager: SessionManagerProtocol { get }
    var delegate: LoginViewModelDelegate? { get set }
}

final class LoginViewModel: LoginViewModelProtocol, LoginTextFieldDelegate {
    
    var dataProvider: DataProviderProtocol
    var sessionManager: SessionManagerProtocol
    
    var didSuccessfullyLogin: ((LoginResponse.User) -> Void)?
    var onLoginError: ((ErrorResponse) -> Void)?
    
    weak var delegate: LoginViewModelDelegate?

    init(dataProvider: DataProviderProtocol = DataProvider(),
         sessionManager: SessionManagerProtocol = SessionManager()
    ) {
        self.dataProvider = dataProvider
        self.sessionManager = sessionManager
    }
    
    func login(email: String, password: String) {
        
        let loginRequest = LoginRequest(email: email, password: password)
        
        dataProvider.login(request: loginRequest) { [weak self] result in
            switch result {
            case .success(let success):
                self?.sessionManager.setUserToken(success.session.bearerToken)
                self?.didSuccessfullyLogin?(success.user)
            case .failure(let error):
                self?.onLoginError?(error)
            }
        }
    }
    
    func loginTextFieldDidReturn(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    func loginTextFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.loginTextFieldDidBeginEditing(textField)
    }
}
