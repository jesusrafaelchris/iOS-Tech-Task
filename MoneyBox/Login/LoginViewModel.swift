import UIKit
import Networking

protocol LoginViewModelProtocol: AnyObject, LoginTextFieldDelegate {
    func login(email: String?, password: String?, completion: @escaping (LoginCompletion))
    func assignSessionToken(token: String)
    var dataProvider: DataProviderProtocol { get }
    var sessionManager: SessionManagerProtocol { get }
}

final class LoginViewModel: LoginViewModelProtocol, LoginTextFieldDelegate {
    
    var dataProvider: DataProviderProtocol
    var sessionManager: SessionManagerProtocol
    
    init(dataProvider: DataProviderProtocol,
         sessionManager: SessionManagerProtocol
    ) {
        self.dataProvider = dataProvider
        self.sessionManager = sessionManager
    }
    
    func login(email: String?, password: String?, completion: @escaping (LoginCompletion)) {
        guard
            let email = email,
            let password = password
        else { return }
        
        let loginRequest = LoginRequest(email: email, password: password)
        
//        dataProvider.login(request: loginRequest) { result in
//            switch result {
//            case .success(let success):
//                print(success)
//                self?.sessionManager.setUserToken(success.session.bearerToken)
//                
//            case .failure(let failure):
//                print(failure)
//            }
//            completion(result)
//        }
        
        dataProvider.login(request: loginRequest, completion: completion)
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
