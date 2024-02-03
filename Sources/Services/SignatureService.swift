//
//  File.swift
//
//
//  Created by Eugene Popov on 2/1/24.
//

import CommonCrypto
import Foundation

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
}

extension Data {
    var bytes: [UInt8] {
        [UInt8](self)
    }
}
