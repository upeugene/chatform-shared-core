//
//  File.swift
//  SharedCore
//
//  Created by Eugene Popov on 11/30/25.
//

import Foundation

public struct TranscribeForm: Codable {
    public var language: String
    public var dataBase64: String

    public init(language: String, dataBase64: String) {
        self.language = language
        self.dataBase64 = dataBase64
    }
}
