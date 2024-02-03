import XCTest
@testable import SharedCore

final class SignatureServiceTests: XCTestCase {
    
    func testGenerateSignatureWithValidData() {
        // Given
        let data = "Hello, world!"
        let key = "secretKey"
        let expectedSignature = "ptq19aO+PVZaNbFC067Tc+3EYhZSTrnk7TIjmNvLZew="
        
        // When
        let signature = SignatureService.generateSignature(data: data, key: key)
        
        // Then
        XCTAssertNotNil(signature, "Signature should not be nil")
        XCTAssertEqual(signature, expectedSignature, "Generated signature does not match the expected signature")
    }
    
    func testGenerateSignatureWithEmptyData() {
        // Given
        let data = ""
        let key = "secretKey"
        
        // When
        let signature = SignatureService.generateSignature(data: data, key: key)
        
        // Then
        XCTAssertNotNil(signature, "Signature should not be nil even with empty data")
    }
    
    func testGenerateSignatureWithEmptyKey() {
        // Given
        let data = "Hello, world!"
        let key = ""
        
        // When
        let signature = SignatureService.generateSignature(data: data, key: key)
        
        // Then
        XCTAssertNil(signature, "Signature should be nil when key is empty")
    }
    
    func testGenerateSignatureReturnsDifferentSignaturesForDifferentKeys() {
        // Given
        let data = "Hello, world!"
        let key1 = "secretKey1"
        let key2 = "secretKey2"
        
        // When
        let signature1 = SignatureService.generateSignature(data: data, key: key1)
        let signature2 = SignatureService.generateSignature(data: data, key: key2)
        
        // Then
        XCTAssertNotNil(signature1, "Signature should not be nil")
        XCTAssertNotNil(signature2, "Signature should not be nil")
        XCTAssertNotEqual(signature1, signature2, "Signatures should be different for different keys")
    }
}
