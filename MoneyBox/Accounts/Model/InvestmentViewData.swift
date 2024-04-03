import Foundation
import Networking

struct InvestmentViewData: Hashable {
    var planValue: Double?
    let moneyBox: Double?
    let isFavourite: Bool?
    let name: String?
    let pngImageUrl: String?
    let friendlyName: String?
    let productHexCode: String?
    var contributionsNet: Double?
    let earningsNet: Double?
    let earningsAsPercentage: Double?
    let assetBox: String?
    let productID: Int?
    
    static var mockData: InvestmentViewData {
        return .init(planValue: 90, moneyBox: 0, isFavourite: false, name: "", pngImageUrl: "", friendlyName: "", productHexCode: "", contributionsNet: 0, earningsNet: 0, earningsAsPercentage: 0, assetBox: "", productID: 0)
    }
}

extension ProductResponse {
    var asViewData: InvestmentViewData {
        return .init(
            planValue: planValue,
            moneyBox: moneybox,
            isFavourite: isFavourite,
            name: product?.name,
            pngImageUrl: product?.pngImageUrl,
            friendlyName: product?.friendlyName,
            productHexCode: product?.productHexCode,
            contributionsNet: investorAccount?.contributionsNet,
            earningsNet: investorAccount?.earningsNet,
            earningsAsPercentage: investorAccount?.earningsAsPercentage,
            assetBox: assetBox?.title,
            productID: id
        )
    }
}
