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
        XCTAssertNil(sut.onFetchError)
    }
    
    func testFetchProductSetsHeaderViewData() throws {
        // Given
        dataProviderMock.fetchProductsResult = .success(AccountResponse.mockData)
        
        // When
        sut.fetchProducts()
        
        // Then
        XCTAssertNotNil(sut.accountsViewData.headerViewData)
        XCTAssertNil(sut.onFetchError)
    }
    
    func testFetchProductSetsInvestmentViewData() throws {
        // Given
        dataProviderMock.fetchProductsResult = .success(AccountResponse.mockData)
        
        // When
        sut.fetchProducts()
        
        // Then
        XCTAssertNotNil(sut.accountsViewData.investmentViewData)
        XCTAssertNil(sut.onFetchError)
    }
    
    func testFetchProductWithErrorCallsOnFetchError() throws {
        // Given
        dataProviderMock.fetchProductsResult = .failure(.init(name: "", message: "Test Error", validationErrors: nil))
        
        // When
        sut.fetchProducts()
        
        // Then
        XCTAssertNil(sut.accountsViewData.headerViewData)
        XCTAssertNil(sut.accountsViewData.investmentViewData)
        XCTAssertNil(sut.didFetchAccounts)
        
        sut.onFetchError = { error in
            XCTAssertEqual(error, "Test Error")
        }
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
