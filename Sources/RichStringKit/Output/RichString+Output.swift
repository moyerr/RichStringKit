// MARK: - RichString Default

extension RichString {
    public func _makeOutput() -> RichStringOutput {
        body._makeOutput()
    }
}

// MARK: - RichString Primitives

// MARK: EmptyString

extension EmptyString {
    public func _makeOutput() -> RichStringOutput {
        .init(RichStringOutput.Content.empty)
    }
}

// MARK: String

extension String {
    public func _makeOutput() -> RichStringOutput { .init(.string(self)) }
}

// MARK: Attachment

extension Attachment {
    public func _makeOutput() -> RichStringOutput {
        .init(.modified(.attachment, .attachment(image)))
    }
}

// MARK: Concatenate

extension Concatenate {
    public func _makeOutput() -> RichStringOutput {
        let outputs = contents.map { richString -> RichStringOutput.Content in
            guard case .content(let value) = richString._makeOutput().storage else {
                preconditionFailure("RichString type \(type(of: richString)) must produce content output")
            }

            return value
        }

        return .init(.sequence(outputs))
    }
}

// MARK: ModifiedContent

extension ModifiedContent where Self: RichString {
    public func _makeOutput() -> RichStringOutput {
        if Modifier.Body.self == Never.self {
            return primitiveModifierOutput()
        } else {
            return composedModifierOutput()
        }
    }

    private func primitiveModifierOutput() -> RichStringOutput {
        guard
            case .content(let lhs) = content._makeOutput().storage,
            case .modifier(let rhs) = modifier._makeOutput().storage
        else {
            preconditionFailure("RichString type \(type(of: content)) must produce content output, and RichStringModifier type \(type(of: modifier)) must produce modifier output")
        }

        return .init(.modified(lhs, rhs))
    }

    private func composedModifierOutput() -> RichStringOutput {
        let wrappedContent = Modifier.Content(content)
        let modifiedContent = modifier.body(wrappedContent)
        let output = modifiedContent._makeOutput()
        return output
    }
}

// MARK: Format

@available(iOS 16, tvOS 16, watchOS 9, macOS 13, *)
extension Format {
    public func _makeOutput() -> RichStringOutput {
        var argContents = args.map { $0._makeOutput().content }

        let formatSpecifier = /%((?<index>\d+)\$)?@/

        return .init(.sequence(
            formatString.transformMatches(of: formatSpecifier) { match, index in
                guard !argContents.isEmpty else { return .string("(null)") }
                return argContents.removeFirst()
            } transformNonMatches: { substring in
                return .string(String(substring))
            }
        ))
    }
}

// MARK: _RichStringModifier_Content

extension _RichStringModifier_Content {
    public func _makeOutput() -> RichStringOutput {
        return content._makeOutput()
    }
}
