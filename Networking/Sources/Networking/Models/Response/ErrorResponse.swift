//
//  ErrorResponse.swift
//  MoneyBox
//
//  Created by Zeynep Kara on 16.01.2022.
//

import Foundation

public enum LoginError {
    case emailError
    case passwordError
    case unknownError
}

// MARK: - ErrorResponse
public struct ErrorResponse: Codable, Error {
    public let name: String?
    public let message: String?
    public let validationErrors: [ValidationError]?

    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case message = "Message"
        case validationErrors = "ValidationErrors"
    }
    
    public struct ValidationError: Codable {
        public let name: String?
        public let message: String?

        enum CodingKeys: String, CodingKey {
            case name = "Name"
            case message = "Message"
        }
    }
    
    public var loginError: LoginError {
        guard let validationErrors = validationErrors else {
            return .unknownError
        }
        
        for error in validationErrors {
            switch error.name {
            case "Email":
                return .emailError
            case "Password":
                return .passwordError
            case "Login failed":
                return .unknownError
            default:
                break
            }
        }
        
        return .unknownError
    }
    
    public var emailError: String {
        return validationErrors?.first(where: { $0.name == "Email"})?.message ?? ""
    }
    
    public var passwordError: String {
        return validationErrors?.first(where: { $0.name == "Password"})?.message ?? ""
    }
}
