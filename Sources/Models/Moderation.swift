//
//  File.swift
//  
//
//  Created by Eugene Popov on 2/6/24.
//

import Foundation

public struct Moderation: Codable {
    public let input: String

    public init(input: String) {
        self.input = input
    }
}
