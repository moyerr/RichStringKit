// MARK: - RichStringModifier Default

extension RichStringModifier {
    public func _makeOutput() -> RichStringOutput {
        // Pass an empty string just to run the body and get type info
        let output = body(.init(EmptyString()))
            ._makeOutput()

        guard
            case .content(let modifiedContent) = output.storage,
            case .modified(let content, let modifier) = modifiedContent
        else {
            // If the output is not modified content, then this must be the empty modifier
            return EmptyModifier()._makeOutput()
        }

        func combineModifiers(
            _ content: RichStringOutput.Content,
            _ modifier: RichStringOutput.Modifier
        ) -> RichStringOutput.Modifier {
            guard case let .modified(nestedContent, nestedModifier) = content else {
                return modifier
            }

            return .combined(
                combineModifiers(nestedContent, nestedModifier),
                modifier
            )
        }

        return .init(combineModifiers(content, modifier))
    }
}

// MARK: - RichStringModifier Primitives

// MARK: EmptyModifier

extension EmptyModifier {
    public func _makeOutput() -> RichStringOutput {
        .init(RichStringOutput.Modifier.empty)
    }
}

// MARK: ModifiedContent

extension ModifiedContent where Self: RichStringModifier {
    public func _makeOutput() -> RichStringOutput {
        let contentOutput = content._makeOutput()
        let modifierOutput = modifier._makeOutput()

        guard
            case .modifier(let lhs) = contentOutput.storage,
            case .modifier(let rhs) = modifierOutput.storage
        else {
            // swiftlint:disable:next line_length
            preconditionFailure("RichStringModifier types \(type(of: content)), \(type(of: modifier)) must produce modifier output")
        }

        return .init(.combined(lhs, rhs))
    }
}
