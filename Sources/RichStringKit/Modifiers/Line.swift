// swiftlint:disable:this file_name

public enum LineStyle {
    case single
    case thick
    case double
    case patternDot
    case patternDash
    case patternDashDot
    case patternDashDotDot
    case byWord
}

public struct StrikethroughStyle: RichStringModifier {
    public typealias Body = Never

    let style: LineStyle

    init(_ style: LineStyle) {
        self.style = style
    }

    public func _makeOutput() -> RichStringOutput {
        .init(.strikethroughStyle(style))
    }
}

public struct UnderlineStyle: RichStringModifier {
    public typealias Body = Never

    let style: LineStyle

    init(_ style: LineStyle) {
        self.style = style
    }

    public func _makeOutput() -> RichStringOutput {
        .init(.underlineStyle(style))
    }
}

// MARK: Modifier Methods

extension RichString {
    public func strikethroughStyle(_ style: LineStyle) -> some RichString {
        modifier(StrikethroughStyle(style))
    }

    public func underlineStyle(_ style: LineStyle) -> some RichString {
        modifier(UnderlineStyle(style))
    }
}
