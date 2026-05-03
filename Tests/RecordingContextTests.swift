import XCTest
@testable import SharedCore

final class RecordingContextTests: XCTestCase {

    func testCommandTargetTextRoundTripsThroughCodable() throws {
        let original = RecordingContext(
            appBundleId: "com.apple.MobileSMS",
            inputFieldText: "hi there",
            commandTargetText: "make it shorter please"
        )

        let encoded = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(RecordingContext.self, from: encoded)

        XCTAssertEqual(decoded.commandTargetText, "make it shorter please")
        XCTAssertEqual(decoded.appBundleId, "com.apple.MobileSMS")
        XCTAssertEqual(decoded.inputFieldText, "hi there")
    }

    func testLegacyPayloadWithoutCommandTargetTextStillDecodes() throws {
        // A payload from a client that pre-dates the field — no `commandTargetText` key.
        let legacyJson = """
        {
          "appBundleId": "com.apple.mail",
          "appName": "Mail",
          "inputFieldText": "Dear John",
          "selectedText": "John"
        }
        """.data(using: .utf8)!

        let decoded = try JSONDecoder().decode(RecordingContext.self, from: legacyJson)

        XCTAssertNil(decoded.commandTargetText)
        XCTAssertEqual(decoded.appBundleId, "com.apple.mail")
        XCTAssertEqual(decoded.appName, "Mail")
        XCTAssertEqual(decoded.inputFieldText, "Dear John")
        XCTAssertEqual(decoded.selectedText, "John")
    }

    func testFullRoundTripPreservesAllFields() throws {
        let original = RecordingContext(
            appBundleId: "com.example.app",
            appName: "Example",
            windowTitle: "Compose",
            visibleText: ["a", "b"],
            selectedText: "sel",
            inputFieldText: "field",
            customStyle: "style",
            commandTargetText: "target"
        )

        let encoded = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(RecordingContext.self, from: encoded)

        XCTAssertEqual(decoded.appBundleId, original.appBundleId)
        XCTAssertEqual(decoded.appName, original.appName)
        XCTAssertEqual(decoded.windowTitle, original.windowTitle)
        XCTAssertEqual(decoded.visibleText, original.visibleText)
        XCTAssertEqual(decoded.selectedText, original.selectedText)
        XCTAssertEqual(decoded.inputFieldText, original.inputFieldText)
        XCTAssertEqual(decoded.customStyle, original.customStyle)
        XCTAssertEqual(decoded.commandTargetText, original.commandTargetText)
    }
}
