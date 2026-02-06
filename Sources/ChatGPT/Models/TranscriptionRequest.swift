//
//  TranscriptionRequest.swift
//  SharedCore
//
//  Created by Eugene Popov on 2/5/26.
//

import Foundation

/// Request metadata for audio transcription (sent as JSON alongside binary audio in multipart)
public struct TranscriptionRequest: Codable, Sendable {
    /// ISO 639 language codes
    public var languages: [String]
    public var context: RecordingContext?

    public init(languages: [String], context: RecordingContext? = nil) {
        self.languages = languages
        self.context = context
    }
}
