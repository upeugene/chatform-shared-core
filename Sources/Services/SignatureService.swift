//
//  File.swift
//
//
//  Created by Eugene Popov on 2/1/24.
//

import CommonCrypto
import Foundation
import Crypto

enum SignatureError: Error {
    case noData
}

public final class SignatureService {
    
    public init() {}
    
    public static func generateSignature(data: String, key: String) -> String? {
        guard !key.isEmpty,
              let keyData = key.data(using: .utf8),
              let dataToSign = data.data(using: .utf8) else { return nil }
        
        var hmac = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA256), keyData.bytes, keyData.count, dataToSign.bytes, dataToSign.count, &hmac)
        let signature = Data(hmac).base64EncodedString()
        return signature
    }
    
    public static func verifySignature(signature: String, data: String, key: String) throws -> Bool {
        guard 
            !key.isEmpty,
            let secretKey = key.data(using: .utf8),
            let data = data.data(using: .utf8) else {
            throw SignatureError.noData
        }
        
        let expectedHMAC = HMAC<SHA256>.authenticationCode(for: data, using: .init(data: secretKey))
        let expectedSignature = Data(expectedHMAC).base64EncodedString()
        
        return signature == expectedSignature
    }
}

extension Data {
    var bytes: [UInt8] {
        [UInt8](self)
    }
}
