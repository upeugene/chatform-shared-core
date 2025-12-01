//
//  File.swift
//  hello
//
//  Created by Eugene Popov on 11/30/25.
//

import Foundation

public struct MultipartPart {
    enum Payload {
        case text(String)
        case file(filename: String, contentType: String, data: Data)
    }
    let name: String
    let payload: Payload
}

public struct MultipartForm {
    public let boundary: String
    private(set) var parts: [MultipartPart] = []

    public init(boundary: String = "Boundary-\(UUID().uuidString)") {
        self.boundary = boundary
    }

    public mutating func addText(name: String, value: String) {
        parts.append(MultipartPart(name: name, payload: .text(value)))
    }

    public mutating func addFile(name: String, filename: String, contentType: String, data: Data) {
        parts.append(MultipartPart(name: name, payload: .file(filename: filename, contentType: contentType, data: data)))
    }

    public func serialize() -> Data {
        var body = Data()

        func append(_ string: String) { body.append(string.data(using: .utf8)!) }

        for part in parts {
            append("--\(boundary)\r\n")
            switch part.payload {
            case .text(let value):
                append("Content-Disposition: form-data; name=\"\(part.name)\"\r\n\r\n")
                append("\(value)\r\n")
            case .file(let filename, let contentType, let data):
                append("Content-Disposition: form-data; name=\"\(part.name)\"; filename=\"\(filename)\"\r\n")
                append("Content-Type: \(contentType)\r\n\r\n")
                body.append(data)
                append("\r\n")
            }
        }
        append("--\(boundary)--\r\n")
        return body
    }
}
