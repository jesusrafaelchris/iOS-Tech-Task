//
//  DataProvider.swift
//  MoneyBox
//
//  Created by Zeynep Kara on 20.07.2022.
//

public typealias LoginCompletion = ((Result<LoginResponse, ErrorResponse>) -> Void)

public protocol DataProviderProtocol: AnyObject {
    func login(request: LoginRequest, completion: @escaping (LoginCompletion))
    func fetchProducts(completion: @escaping ((Result<AccountResponse, ErrorResponse>) -> Void))
    func addMoney(request: OneOffPaymentRequest, completion: @escaping ((Result<OneOffPaymentResponse, ErrorResponse>) -> Void))
}

public class DataProvider: DataProviderProtocol {
    public init() {}
    public func login(request: LoginRequest, completion: @escaping ((Result<LoginResponse, ErrorResponse>) -> Void)) {
        API.Login.login(request: request).fetchResponse(completion: completion)
    }
    
    public func fetchProducts(completion: @escaping ((Result<AccountResponse, ErrorResponse>) -> Void)) {
        API.Account.products.fetchResponse(completion: completion)
    }
    
    public func addMoney(request: OneOffPaymentRequest, completion: @escaping ((Result<OneOffPaymentResponse, ErrorResponse>) -> Void)) {
        API.Account.addMoney(request: request).fetchResponse(completion: completion)
    }
}
