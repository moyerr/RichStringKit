import XCTest
@testable import RichStringKit

final class NSAttributedStringRendererPerformanceTests: XCTestCase {
    private struct Fixture<Content: RichString>: RichString {
        @RichStringBuilder var content: () -> Content

        var body: some RichString {
            content()
        }
    }

    let metrics: [XCTMetric] = [XCTCPUMetric(), XCTClockMetric(), XCTMemoryMetric()]

    func testSingleStringPerformance() {
        let singleString = Fixture { "Test" }

        measure(metrics: metrics) {
            _ = singleString.renderNSAttributedString()
        }
    }

    func testMultipleStringPerformance() {
        let multipleStrings = Fixture {
            "Hello "
            "World!"
        }

        measure(metrics: metrics) {
            _ = multipleStrings.renderNSAttributedString()
        }
    }

    func testModifiedStringPerformance() {
        let modifiedString = Fixture {
            "Test"
                .kern(8)
        }

        measure(metrics: metrics) {
            _ = modifiedString.renderNSAttributedString()
        }
    }

    func testMultipleModificationsPerformance() {
        let multipleModifications = Fixture {
            "Test"
                .baselineOffset(8)
                .underlineStyle(.double)
        }

        measure(metrics: metrics) {
            _ = multipleModifications.renderNSAttributedString()
        }
    }

    func testConcatenationWithModificationsPerformance() {
        let concatenationAndModifications = Fixture {
            "Hello"
                .underlineStyle(.double)

            " World!"
                .kern(8)
        }

        measure(metrics: metrics) {
            _ = concatenationAndModifications.renderNSAttributedString()
        }
    }
}
