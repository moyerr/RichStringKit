@testable import RichStringKit

extension Image {
    #if os(macOS)
    static let testImage = Image(systemSymbolName: "plus", accessibilityDescription: nil)!
    #else
    static let testImage = Image(systemName: "plus")!
    #endif
}
