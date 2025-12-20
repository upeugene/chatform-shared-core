import Foundation

public struct CreateCheckoutSessionRequest: Codable, Sendable  {
    public let plan: String

    public init(plan: String) {
        self.plan = plan
    }
}

public struct CreateCheckoutSessionResponse: Codable, Sendable  {
    public let checkoutUrl: String

    public init(checkoutUrl: String) {
        self.checkoutUrl = checkoutUrl
    }
}

public enum BillingPlan: String {
    case monthly
    case yearly
}

public struct BillingPriceConfiguration: Sendable {
    public let monthlyPriceID: String
    public let yearlyPriceID: String

    public init(monthlyPriceID: String, yearlyPriceID: String) {
        self.monthlyPriceID = monthlyPriceID
        self.yearlyPriceID = yearlyPriceID
    }

    public  func priceID(for plan: BillingPlan) -> String {
        switch plan {
        case .monthly:
            return monthlyPriceID
        case .yearly:
            return yearlyPriceID
        }
    }
}
