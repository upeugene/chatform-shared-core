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

public enum BillingPlan: String, Codable, Sendable, CaseIterable {
    case monthly
    case yearly
}

public enum SubscriptionState: String, Codable, Sendable, CaseIterable {
    case active
    case trialing
}

public struct SubscriptionStatus: Codable, Sendable, Equatable {
    public let plan: BillingPlan?
    public let state: SubscriptionState?
    public var isActive: Bool {
        state == .active
    }

    public init(
        plan: BillingPlan?,
        state: SubscriptionState?
    ) {
        self.plan = plan
        self.state = state
    }
}

public struct UserProfile: Codable, Sendable, Equatable {
    public let uid: String
    public let email: String?
    public let subscriptionStatus: SubscriptionStatus

    public init(uid: String, email: String?, subscription: SubscriptionStatus) {
        self.uid = uid
        self.email = email
        self.subscriptionStatus = subscription
    }
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
