import XCTest
@testable import MoneyBox
@testable import Networking

final class AccountsViewModelTests: XCTestCase {
    
    private var sut: AccountsViewModelProtocol!
    private var dataProviderMock: DataProviderMock!
    private var mockUser = LoginResponse.mockUser
    
    override func setUp() {
        super.setUp()
        dataProviderMock = DataProviderMock()
        sut = AccountsViewModel(dataProvider: dataProviderMock, user: mockUser)
    }
    
    override func tearDown() {
        dataProviderMock = nil
        sut = nil
        super.tearDown()
    }
    
    func testFetchProductsSetsGreeting() throws {
        // Given
        dataProviderMock.fetchProductsResult = .success(AccountResponse.mockData)
        
        // When
        sut.fetchProducts()
        
        // Then
        XCTAssertEqual(sut.accountsViewData.headerViewData?.greeting,  "\(sut.greetingForTime()), \(mockUser.firstName ?? "")")
    }
    
    func testFetchProductSetsHeaderViewData() throws {
        // Given
        dataProviderMock.fetchProductsResult = .success(AccountResponse.mockData)
        
        // When
        sut.fetchProducts()
        
        // Then
        XCTAssertNotNil(sut.accountsViewData.headerViewData)
    }
    
    func testFetchProductSetsInvestmentViewData() throws {
        // Given
        dataProviderMock.fetchProductsResult = .success(AccountResponse.mockData)
        
        // When
        sut.fetchProducts()
        
        // Then
        XCTAssertNotNil(sut.accountsViewData.investmentViewData)
    }
    
    func testFetchProductWithErrorGivesFailureState() throws {
        // Given
        dataProviderMock.fetchProductsResult = .failure(.init(name: "", message: "Test Error", validationErrors: nil))
        let expectation = XCTestExpectation(description: "Failure State")
        
        // When
        sut.fetchStateDidChange = { state in
            switch state {
            case .failure(let errorMessage):
                XCTAssertEqual(errorMessage, "Test Error")
                expectation.fulfill()
            case .loading:
                XCTFail("Method should fail")
            case .success:
                XCTFail("Method should fail")
            }
        }
        
        // Then
        sut.fetchProducts()
        
        wait(for: [expectation], timeout: 5)
    }
    
    func testFetchProductWithSuccessGivesSuccessState() throws {
        // Given
        dataProviderMock.fetchProductsResult = .success(AccountResponse.mockData)
        let expectation = XCTestExpectation(description: "Success State")
        
        // When
        sut.fetchStateDidChange = { state in
            switch state {
            case .failure:
                XCTFail("Method should fail")
            case .loading:
                XCTFail("Method should fail")
            case .success:
                XCTAssertEqual(self.sut.accountsViewData.headerViewData?.totalPlanValue, AccountResponse.mockData.totalPlanValue)
                expectation.fulfill()
            }
        }
        
        // Then
        sut.fetchProducts()
        
        wait(for: [expectation], timeout: 5)
    }
    
//    func testFetchProductWithSuccessCallsDidFetchAccounts() throws {
//        // Given
//        dataProviderMock.fetchProductsResult = .success(AccountResponse.mockData)
//        
//        // When
//        sut.fetchProducts()
//        
//        // Then
//        XCTAssertNil(sut.onFetchError)
//        XCTAssertNotNil(sut.didFetchAccounts)
//    }
}
