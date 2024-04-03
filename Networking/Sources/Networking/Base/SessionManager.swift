//
//  SessionManager.swift
//  MoneyBox
//
//  Created by Zeynep Kara on 18.07.2022.
//

import Foundation

public protocol SessionManagerProtocol: AnyObject {
    func setUserToken(_ token: String)
    func removeUserToken()
}

public final class SessionManager: NSObject, SessionManagerProtocol {
    public func setUserToken(_ token: String) {
        Authentication.token = token
    }
    
    public func removeUserToken() {
        Authentication.token = nil
    }
}
