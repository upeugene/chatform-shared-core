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
    public var visibleText: [String]?
    public var selectedText: String?
    public var inputFieldText: String?
    public var customStyle: String?
    public var commandTargetText: String?

    public init(
        appBundleId: String? = nil,
        appName: String? = nil,
        windowTitle: String? = nil,
        visibleText: [String]? = nil,
        selectedText: String? = nil,
        inputFieldText: String? = nil,
        customStyle: String? = nil,
        commandTargetText: String? = nil
    ) {
        self.appBundleId = appBundleId
        self.appName = appName
        self.windowTitle = windowTitle
        self.visibleText = visibleText
        self.selectedText = selectedText
        self.inputFieldText = inputFieldText
        self.customStyle = customStyle
        self.commandTargetText = commandTargetText
    }
}
