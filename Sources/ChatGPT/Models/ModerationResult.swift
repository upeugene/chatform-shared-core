//
//  File.swift
//  
//
//  Created by Eugene Popov on 2/6/24.
//

import Foundation

public struct ModerationResult: Codable, Equatable {
    let id: String
    let model: String
    let results: [Result]

    public var isFlagged: Bool {
        guard let isFlagged = results.first?.flagged else { return false }
        return isFlagged
    }

    struct Result: Codable, Equatable {
        let flagged: Bool
        let categories: Categories
        let categoryScores: [String: Double]

        enum CodingKeys: String, CodingKey {
            case flagged
            case categories
            case categoryScores = "category_scores"
        }
        struct Categories: Codable, Equatable {
            let sexual: Bool
            let hate: Bool
            let harassment: Bool
            let selfHarm: Bool
            let sexualMinors: Bool
            let hateThreatening: Bool
            let violenceGraphic: Bool
            let selfHarmIntent: Bool
            let selfHarmInstructions: Bool
            let harassmentThreatening: Bool
            let violence: Bool

            enum CodingKeys: String, CodingKey {
                case sexual
                case hate
                case harassment
                case selfHarm = "self-harm"
                case sexualMinors = "sexual/minors"
                case hateThreatening = "hate/threatening"
                case violenceGraphic = "violence/graphic"
                case selfHarmIntent = "self-harm/intent"
                case selfHarmInstructions = "self-harm/instructions"
                case harassmentThreatening = "harassment/threatening"
                case violence
            }
        }
    }
}
