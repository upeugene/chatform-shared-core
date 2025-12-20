//
//  File.swift
//  SharedCore
//
//  Created by Eugene Popov on 12/1/25.
//

import Foundation

public struct TranscribeResponse: Codable, Sendable {
    public var text: String

    public init(text: String) {
        self.text = text
    }
}
