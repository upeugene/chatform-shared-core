//
//  File.swift
//  SharedCore
//
//  Created by Eugene Popov on 11/30/25.
//

import Foundation

public struct TranscribeForm: Codable {
    // ISO 639
    public var languages: [String]
    public var dataBase64: String

    public init(languages: [String], dataBase64: String) {
        self.languages = languages
        self.dataBase64 = dataBase64
    }
}
