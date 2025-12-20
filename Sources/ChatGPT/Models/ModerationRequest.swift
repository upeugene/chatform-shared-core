//
//  File.swift
//  
//
//  Created by Eugene Popov on 2/6/24.
//

import Foundation

public struct ModerationRequest: Codable {
    public let input: String

    public init(input: String) {
        self.input = input
    }
}
