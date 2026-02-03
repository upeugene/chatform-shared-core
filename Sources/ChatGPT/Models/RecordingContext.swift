//
//  RecordingContext.swift
//  SharedCore
//
//  Created by Eugene Popov on 01/26/26.
//

import Foundation

public struct RecordingContext: Codable, Sendable {
    public var appBundleId: String?
    public var appName: String?
    public var windowTitle: String?

    public init(
        appBundleId: String? = nil,
        appName: String? = nil,
        windowTitle: String? = nil
    ) {
        self.appBundleId = appBundleId
        self.appName = appName
        self.windowTitle = windowTitle
    }
}
