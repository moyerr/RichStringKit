public struct RichStringOutput: Equatable {
    enum Modifier: Equatable {
        case foregroundColor(Color)
        case backgroundColor(Color)
        indirect case combined(Modifier, Modifier)
    }

    enum Content: Equatable {
        case empty
        case string(String)
        indirect case modified(Content, Modifier)
        indirect case sequence([Content])
    }

    enum Storage: Equatable {
        case content(Content)
        case modifier(Modifier)
    }

    let storage: Storage

    init(_ content: Content) {
        self.storage = .content(content)
    }

    init(_ modifier: Modifier) {
        self.storage = .modifier(modifier)
    }
}

// MARK: RichString Default

extension RichString {
    public func _makeOutput() -> RichStringOutput {
        body._makeOutput()
    }
}

// MARK: RichString Primitives

extension EmptyString {
    public func _makeOutput() -> RichStringOutput { .init(.empty) }
}

extension String {
    public func _makeOutput() -> RichStringOutput { .init(.string(self)) }
}

extension ModifiedContent where Self: RichString {
    public func _makeOutput() -> RichStringOutput {
        guard
            case .content(let lhs) = content._makeOutput().storage,
            case .modifier(let rhs) = modifier._makeOutput().storage
        else {
            preconditionFailure("Content type \(type(of: content)) must produce content output, and Modifier type \(type(of: modifier)) must produce modifier output")
        }

        return .init(.modified(lhs, rhs))
    }
}

extension Concatenation {
    public func _makeOutput() -> RichStringOutput {
        let outputs = contents.map { richString -> RichStringOutput.Content in
            guard case .content(let value) = richString._makeOutput().storage else {
                preconditionFailure("Content type \(type(of: richString)) must produce content output")
            }
            
            return value
        }

        return .init(.sequence(outputs))
    }
}

// MARK: RichStringModifier Default

extension RichStringModifier {
    public func _makeOutput() -> RichStringOutput {
        body(.init())._makeOutput()
    }
}

// MARK: RichStringModifier Primitives

extension ForegroundColor {
    public func _makeOutput() -> RichStringOutput {
        .init(.foregroundColor(color))
    }
}

extension BackgroundColor {
    public func _makeOutput() -> RichStringOutput {
        .init(.backgroundColor(color))
    }
}

extension ModifiedContent where Self: RichStringModifier {
    public func _makeOutput() -> RichStringOutput {
        guard
            case .modifier(let lhs) = content._makeOutput().storage,
            case .modifier(let rhs) = modifier._makeOutput().storage
        else {
            preconditionFailure("Modifier types \(type(of: content)), \(type(of: modifier)) must produce modifier output")
        }

        return .init(.combined(lhs, rhs))
    }
}
