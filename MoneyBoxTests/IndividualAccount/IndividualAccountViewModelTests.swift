import XCTest
@testable import MoneyBox
@testable import Networking

final class IndividualAccountViewModelTests: XCTestCase {
    
    private var sut: IndividualAccountViewModelProtocol!
    private var dataProviderMock: DataProviderMock!
    private var mockAccount = InvestmentViewData.mockData
    
    override func setUp() {
        super.setUp()
        dataProviderMock = DataProviderMock()
        sut = IndividualAccountViewModel(dataProvider: dataProviderMock, account: mockAccount)
    }
    
    override func tearDown() {
        dataProviderMock = nil
        sut = nil
        super.tearDown()
    }
    
    func testSuccessfulMoneyAdd() {
        // Given
        dataProviderMock.addMoneyResult = .success(OneOffPaymentResponse.mockData)
        let expectation = XCTestExpectation(description: "Money added successfully")
        
        // When
        sut.didAddMoney = { amount in
            XCTAssertEqual(amount, 100)
            expectation.fulfill()
        }
        
        sut.addMoneyFailure = { error in
            XCTFail("Should not fail")
        }
        
        // Then
        sut.addMoney(amount: 10)
        
        wait(for: [expectation], timeout: 5)
    }
    
    
    func testIfSuccessfulThenMoneyIncreasesByAmount() {
        // Given
        let initialBalance = sut.account.planValue ?? 0
        dataProviderMock.addMoneyResult = .success(OneOffPaymentResponse.mockData)
        let expectation = XCTestExpectation(description: "Money added successfully")
        
        // When
        sut.didAddMoney = { amount in
            XCTAssertEqual(amount, initialBalance + 10)
            expectation.fulfill()
        }
        
        sut.addMoneyFailure = { error in
            XCTFail("Should not fail")
        }
        
        // Then
        sut.addMoney(amount: 10)
        
        wait(for: [expectation], timeout: 5)
    }

    func testFailureMoneyAdd() {
        // Given
        dataProviderMock.addMoneyResult = .failure(.init(name: "", message: "Test Error", validationErrors: nil))
        let expectation = XCTestExpectation(description: "Money addition failed")
        
        // When
        sut.didAddMoney = { amount in
            XCTFail("Should not succeed")
        }
        
        sut.addMoneyFailure = { error in
            XCTAssertEqual(error, "Test Error")
            expectation.fulfill()
        }
        
        // Then
        sut.addMoney(amount: 10)
        
        wait(for: [expectation], timeout: 5)
    }
}
