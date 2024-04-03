import Foundation
import Networking

class DataProviderMock: DataProviderProtocol {
    
    var loginResult: Result<LoginResponse, ErrorResponse>?
    var fetchProductsResult: Result<AccountResponse, ErrorResponse>?
    var addMoneyResult: Result<OneOffPaymentResponse, ErrorResponse>?

    func login(request: LoginRequest, completion: @escaping (LoginCompletion)) {
        if let result = loginResult {
            completion(result)
        }
    }

    func fetchProducts(completion: @escaping ((Result<AccountResponse, ErrorResponse>) -> Void)) {
        if let result = fetchProductsResult {
            completion(result)
        }
    }

    func addMoney(request: OneOffPaymentRequest, completion: @escaping ((Result<OneOffPaymentResponse, ErrorResponse>) -> Void)) {
        if let result = addMoneyResult {
            completion(result)
        }
    }
}
