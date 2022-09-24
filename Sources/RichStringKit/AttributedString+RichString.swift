import Foundation
import SwiftUI

extension AttributedString {
    public init(@RichStringBuilder _ content: () -> some RichString) {
        self = AttributedString(.richString(content))
    }

    public init(_ content: some RichString) {
        self = AttributedString(.richString(content))
    }
}

extension Text {
    public init(@RichStringBuilder _ content: () -> some RichString) {
        self = Text(AttributedString(content))
    }

    public init(_ content: some RichString) {
        self = Text(AttributedString(content))
    }
}
