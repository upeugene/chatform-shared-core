//
//  CorrectionRequest.swift
//  SharedCore
//
//  Created by Eugene Popov on 2/27/26.
//

import Foundation

/// Request body for the text correction endpoint (POST /v1/correct).
/// Sent as JSON. Contains raw transcribed text plus context for GPT correction.
public struct CorrectionRequest: Codable, Sendable {
    /// Raw transcribed text to be corrected
    public var text: String
    /// ISO 639 language codes the user is dictating in
    public var languages: [String]
    /// App context for style-aware correction
    public var context: RecordingContext?

    public init(text: String, languages: [String], context: RecordingContext? = nil) {
        self.text = text
        self.languages = languages
        self.context = context
    }
}
