import XCTest
@testable import MoneyBox
@testable import Networking

final class LoginViewModelTests: XCTestCase {
    
    private var sut: LoginViewModelProtocol!
    private var dataProviderMock: DataProviderMock!
    private var sessionManagerStub: SessionManagerStub!

    override func setUp() {
        super.setUp()
        dataProviderMock = DataProviderMock()
        sessionManagerStub = SessionManagerStub()
        sut = LoginViewModel(dataProvider: dataProviderMock, sessionManager: sessionManagerStub)
    }

    override func tearDown() {
        dataProviderMock = nil
        sessionManagerStub = nil
        sut = nil
        super.tearDown()
    }

    func testLoginWithInvalidEmailThrowsEmailError() {
        // Given
        let expectation = XCTestExpectation(description: "Login error is handled")

        dataProviderMock.loginResult = .failure(ErrorResponse.init(name: nil, message: nil, validationErrors: [.init(name: "Email", message: nil)]))

        // When

        sut.didSuccessfullyLogin = { user in
            XCTFail("Method Should fail with invalid email")
        }

        sut.onLoginError = { error in
            XCTAssertEqual(error.loginError, LoginError.emailError)
            expectation.fulfill()
        }
        
        // Then
        sut.login(email: "", password: "")

        wait(for: [expectation], timeout: 3)
    }
    
    func testLoginWithInvalidPasswordThrowsPasswordError() {
        // Given
        let expectation = XCTestExpectation(description: "Password error is handled")
        expectation.assertForOverFulfill = true

        dataProviderMock.loginResult = .failure(ErrorResponse.init(name: nil, message: nil, validationErrors: [.init(name: "Password", message: nil)]))

        // When
        sut.didSuccessfullyLogin = { user in
            XCTFail("Method Should fail with invalid password")
        }

        sut.onLoginError = { error in
            XCTAssertEqual(error.loginError, LoginError.passwordError)
            expectation.fulfill()
        }
        
        // Then
        sut.login(email: "test@gmail.com", password: "")
        
        wait(for: [expectation], timeout: 5)
    }

    
    func testLoginWithBothInvalidThrowsUnknownError() {
        // Given
        let expectation = XCTestExpectation(description: "Unknown error is handled")
        expectation.assertForOverFulfill = true

        dataProviderMock.loginResult = .failure(ErrorResponse.init(name: nil, message: nil, validationErrors: [.init(name: nil, message: nil)]))

        // When
        sut.didSuccessfullyLogin = { user in
            XCTFail("Method should not succeed")
        }

        sut.onLoginError = { error in
            XCTAssertEqual(error.loginError, LoginError.unknownError)
            expectation.fulfill()
        }
        
        // Then
        sut.login(email: "gobbledeegook", password: "gobbledeegook")

        wait(for: [expectation], timeout: 5)
    }

    func testAfterLoggingInThenSetUserTokenIsCalled() {
        // Given
        let expectation = XCTestExpectation(description: "Set user token is called")

        dataProviderMock.loginResult = .success(LoginResponse.mockData)
        XCTAssertFalse(sessionManagerStub.setUserTokenCalled)

        // When
        sut.didSuccessfullyLogin = { user in
            XCTAssertTrue(self.sessionManagerStub.setUserTokenCalled)
            expectation.fulfill()
        }

        sut.onLoginError = { error in
            XCTFail("Method Should not provide an error")
        }
        
        // Then
        sut.login(email: "test@gmail.com", password: "password")

        wait(for: [expectation], timeout: 5)
    }

    func testAfterLoggingInThenSessionTokenIsSet() {
        // Given
        let expectation = XCTestExpectation(description: "Session token is set")

        dataProviderMock.loginResult = .success(LoginResponse.mockData)
        XCTAssertFalse(sessionManagerStub.setUserTokenCalled)

        // When
        sut.didSuccessfullyLogin = { user in
            XCTAssertEqual(self.sessionManagerStub.sessionToken, LoginResponse.mockData.session.bearerToken)
            expectation.fulfill()
        }

        sut.onLoginError = { error in
            XCTFail("Method Should not provide an error")
        }
        
        // Then
        sut.login(email: "test@gmail.com", password: "password")

        wait(for: [expectation], timeout: 5)
    }

    func testSuccessfulLoginGivesUserModel() {
        // Given
        let expectation = XCTestExpectation(description: "Successful login gives user model")

        dataProviderMock.loginResult = .success(LoginResponse.mockData)

        // When

        sut.didSuccessfullyLogin = { user in
            XCTAssertEqual(user.firstName, "Michael")
            XCTAssertEqual(user.lastName, "Jordan")
            expectation.fulfill()
        }

        sut.onLoginError = { error in
            XCTFail("Method should not fail")
        }
        
        // Then
        sut.login(email: "test+ios@moneyboxapp.com", password: "password")

        wait(for: [expectation], timeout: 5)
    }

}
