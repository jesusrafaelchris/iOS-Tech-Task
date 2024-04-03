import Foundation
import Networking

class SessionManagerStub: SessionManagerProtocol {
    
    var setUserTokenCalled = false
    var removeUserTokenCalled = false
    var sessionToken: String?

    func setUserToken(_ token: String) {
        setUserTokenCalled = true
        sessionToken = token
    }

    func removeUserToken() {
        removeUserTokenCalled = true
    }
}
