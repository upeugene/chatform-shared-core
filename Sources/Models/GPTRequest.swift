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

public enum GPTModel: String {
    case gpt4turbo = "gpt-4-turbo"
    case gpt35 = "gpt-3.5-turbo"
}

public struct GPTRequest: Codable {
    public let model: String
    public let messages: [ChatGPTResult.Message]

    public init(model: GPTModel, messages: [ChatGPTResult.Message]) {
        self.model = model.rawValue
        self.messages = messages
    }

    public init(system: String?, user: String, model: GPTModel) {
        let userMessage = ChatGPTResult.Message(role: Constant.userRole, content: user)
        if let system {
            let systemMessage = ChatGPTResult.Message(role: Constant.systemRole, content: system)
            self.init(model: model, messages: [systemMessage, userMessage])
        } else {
            self.init(model: model, messages: [userMessage])
        }
    }
}
