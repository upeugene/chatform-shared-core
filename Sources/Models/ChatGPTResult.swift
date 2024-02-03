//
//  File.swift
//  
//
//  Created by Eugene Popov on 2/2/24.
//

import Foundation

public struct ChatGPTResult: Decodable {
    public init(id: String, object: String, model: String, usage: ChatGPTResult.Usage, choices: [ChatGPTResult.Choice]) {
        self.id = id
        self.object = object
        self.model = model
        self.usage = usage
        self.choices = choices
    }

    public let id: String
    public let object: String
    //    let created: Int
    public let model: String
    public let usage: Usage
    public let choices: [Choice]

    public struct Message: Codable {
        public init(role: String, content: String) {
            self.role = role
            self.content = content
        }

        public let role: String
        public let content: String
    }
    
    public struct Usage: Decodable {
        public init(promptTokens: Int, completionTokens: Int, totalTokens: Int) {
            self.promptTokens = promptTokens
            self.completionTokens = completionTokens
            self.totalTokens = totalTokens
        }

        enum CodingKeys: String, CodingKey {
            case promptTokens = "prompt_tokens"
            case completionTokens = "completion_tokens"
            case totalTokens = "total_tokens"
        }
        public let promptTokens: Int
        public let completionTokens: Int
        public let totalTokens: Int
    }

    public struct Choice: Decodable {
        public init(message: ChatGPTResult.Message, finishReason: String, index: Int) {
            self.message = message
            self.finishReason = finishReason
            self.index = index
        }

        enum CodingKeys: String, CodingKey {
            case finishReason = "finish_reason"
            case message
            case index
        }
        public let message: Message
        public let finishReason: String
        public let index: Int
    }

}
