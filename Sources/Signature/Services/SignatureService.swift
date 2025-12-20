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
/*
 SignatureService – Request Signing and Verification

 Overview
 - Purpose: Provide a simple, deterministic way to bind a client request to user-provided content using an HMAC-SHA256 signature that the server can verify.
 - Components:
   - Constants: HTTP header keys used to transport signing metadata.
   - makeSignatureHeaders(data:): Client-side convenience that generates Timestamp, Nonce, and Signature headers.
   - makeKey(data:timestamp:nonce:): Derives a per-request symmetric key from the provided metadata and input data.
   - generateSignature(data:key:): Computes base64(HMAC-SHA256(data, key)).
   - verifySignature(signature:data:key:): Recomputes and compares the expected signature on the server.

 Exact Path of Code Generation (Client → Server)
 1) Client extracts the last user message text (see iOS OpenAIService.obtainResultV2). Let this be `lastMessage`.
 2) Client calls SignatureService.makeSignatureHeaders(data: lastMessage)
    a) timestamp = String(Date().timeIntervalSince1970)
       - Note: This is a string representation of a Double (e.g., "1732972123.12345"). The exact string is used in key derivation; do not reformat on the server.
    b) nonce = random alphanumeric string (length = 16)
    c) key = makeKey(data: lastMessage, timestamp: timestamp, nonce: nonce)
       - Internally: constrainedData = lastMessage.prefix(30)
       - key = timestamp + nonce + constrainedData
    d) signature = generateSignature(data: lastMessage, key: key)
       - keyBytes = UTF-8(key)
       - dataBytes = UTF-8(lastMessage)
       - hmac = HMAC<SHA256>.authenticationCode(for: dataBytes, using: SymmetricKey(data: keyBytes))
       - signature = base64(Data(hmac))
    e) Return headers:
       Timestamp: <timestamp>
       Nonce: <nonce>
       Signature: <signature>
 3) Client attaches these headers to the POST /openai/v2/chat request.

 4) Server receives the request (see Vapor routes v2Group.post("chat", use: chatHandler))
    a) Parse body as OpenAIRequest and read the last message content: `message = payload.messages.last?.content`
    b) Extract headers: Timestamp, Nonce, Signature
    c) key = SignatureService.makeKey(data: message, timestamp: timestamp, nonce: nonce)
    d) isVerified = try SignatureService.verifySignature(signature: signature, data: message, key: key)
    e) If verified, proceed to ChatService().chatV2; otherwise respond with 401/unauthorized.

 Code References
 - iOS client: OpenAIService.obtainResultV2 and fireChatRequest (adds headers from makeSignatureHeaders).
 - Server (Vapor): routes(_:), v2Group.post("chat", use: chatHandler) (extracts headers, recomputes key, verifies signature).

 Security Notes & Considerations
 - Binding scope: The signature binds to the last message content only, not the entire JSON payload. If you need stronger integrity, sign a canonicalized representation of the full request.
 - Freshness & replay: Timestamp and nonce are generated, but this module does not enforce freshness or uniqueness. The server should validate the timestamp window and/or nonce uniqueness to prevent replay attacks.
 - Data truncation in key derivation: Only the first 30 characters of `data` are included in the derived key (makeKey). The signature itself still uses the full `data`. Changing characters beyond index 30 does not affect the key but will affect the HMAC input, so the signature still changes.
 - Exact string formats: Both sides must use the exact same `timestamp` string and `data` bytes (including whitespace and punctuation). Any normalization may break verification.
 */
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
