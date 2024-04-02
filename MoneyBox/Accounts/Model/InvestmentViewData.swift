import Foundation
import Networking

struct InvestmentViewData: Hashable {
    let planValue: Double?
    let totalCollection: Double?
    let isFavourite: Bool?
    let name: String?
    let pngImageUrl: String?
    let friendlyName: String?
    let productHexCode: String?
    let contributionsNet: Double?
    let earningsNet: Double?
    let earningsAsPercentage: Double?
    let assetBox: String?
}

extension ProductResponse {
    var asViewData: InvestmentViewData {
        return .init(
            planValue: planValue,
            totalCollection: product?.totalCollection,
            isFavourite: isFavourite,
            name: product?.name,
            pngImageUrl: product?.pngImageUrl,
            friendlyName: product?.friendlyName,
            productHexCode: product?.productHexCode,
            contributionsNet: investorAccount?.contributionsNet,
            earningsNet: investorAccount?.earningsNet,
            earningsAsPercentage: investorAccount?.earningsAsPercentage,
            assetBox: assetBox?.title
        )
    }
}
