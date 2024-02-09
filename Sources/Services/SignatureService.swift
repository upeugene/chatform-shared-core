//
//  File.swift
//
//
//  Created by Eugene Popov on 2/1/24.
//

import Foundation
import Crypto

enum SignatureError: Error {
    case noData
}

public final class SignatureService {
    public enum Constants {
        public static let timestamp = "Timestamp"
        public static let nonce = "Nonce"
        public static let signature = "Signature"
    }
    
    public init() {}
    
    public static func generateSignature(data: String, key: String) -> String? {
        guard !key.isEmpty,
              let keyData = key.data(using: .utf8),
              let dataToSign = data.data(using: .utf8)
        else { return nil }
        
        let key = SymmetricKey(data: keyData)
        let hmac = HMAC<SHA256>.authenticationCode(for: dataToSign, using: key)
        let signature = Data(hmac).base64EncodedString()
        return signature
    }
    
    public static func verifySignature(signature: String, data: String, key: String) throws -> Bool {
        guard
            !key.isEmpty,
            let dataCode = data.data(using: .utf8),
            let secretKey = key.data(using: .utf8) else {
            throw SignatureError.noData
        }
        
        let expectedHMAC = HMAC<SHA256>.authenticationCode(
            for: dataCode,
            using: SymmetricKey(data: secretKey))
        let expectedSignature = Data(expectedHMAC).base64EncodedString()
        
        return signature == expectedSignature
    }
    
    public static func makeKey(data: String, timestamp: String, nonce: String) -> String {
        let constrainedData = String(data.prefix(30))
        return "\(timestamp)\(nonce)\(constrainedData)"
    }
    
    public static func makeSignatureHeaders(data: String) -> [String: String]? {
        let timestamp = String(Date().timeIntervalSince1970)
        let nonce = Self.generateNonce(length: 16)
        let key = Self.makeKey(data: data, timestamp: timestamp, nonce: nonce)
        guard let signature = Self.generateSignature(data: data, key: key) else { return nil }
        
        return [
            Constants.timestamp: timestamp,
            Constants.nonce: nonce,
            Constants.signature: signature
        ]
    }
    
    private static func generateNonce(length: Int) -> String {
        let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map { _ in characters.randomElement()! })
    }
}

extension Data {
    var bytes: [UInt8] {
        [UInt8](self)
    }
}
