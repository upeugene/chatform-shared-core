//
//  File.swift
//  
//
//  Created by Eugene Popov on 2/2/24.
//

import Foundation

public enum Constant {
    public static let systemRole = "system"
    public static let userRole = "user"
    public static let assistantRole = "assistant"
    public static let prefixAssistant = ""
}


public struct GPTRequest: Codable {
    public let model: String
    public let messages: [ChatGPTResult.Message]

    public init(messages: [ChatGPTResult.Message]) {
        #if DEBUG
        self.model = "gpt-4"
        #else
        self.model = "gpt-3.5-turbo"
        #endif
        
        self.messages = messages
    }

    public init(system: String?, user: String) {
        let userMessage = ChatGPTResult.Message(role: Constant.userRole, content: user)
        if let system {
            let systemMessage = ChatGPTResult.Message(role: Constant.systemRole, content: system)
            self.init(messages: [systemMessage, userMessage])
        } else {
            self.init(messages: [userMessage])
        }
    }
}
