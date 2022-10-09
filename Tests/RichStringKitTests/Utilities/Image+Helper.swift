@testable import RichStringKit

// swiftlint:disable force_unwrapping
extension Image {
    #if os(macOS)
    static let testImage = Image(systemSymbolName: "plus", accessibilityDescription: nil)!
    #else
    static let testImage = Image(systemName: "plus")!
    #endif
}
