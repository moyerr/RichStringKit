import Foundation
import SwiftUI

public extension AttributedString {
    init(@RichStringBuilder _ content: () -> some RichString) {
        self = AttributedString(.richString(content))
    }

    init(_ content: some RichString) {
        self = AttributedString(.richString(content))
    }
}

public extension Text {
    init(@RichStringBuilder _ content: () -> some RichString) {
        self = Text(AttributedString(content))
    }

    init(_ content: some RichString) {
        self = Text(AttributedString(content))
    }
}

