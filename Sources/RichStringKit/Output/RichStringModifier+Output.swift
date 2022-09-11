// MARK: - RichStringModifier Default

extension RichStringModifier {
    public func _makeOutput() -> RichStringOutput {
        // Pass an empty string just to run the body and get type info
        let output = body(.init(EmptyString()))
            ._makeOutput()

        guard
            case .content(let modifiedContent) = output.storage,
            case .modified(let content, let modifiers) = modifiedContent
        else {
            // If the output is not modified content,
            // then this must be the empty modifier.
            return EmptyModifier()._makeOutput()
        }

        return .init(content
            .reduce(into: []) { array, nextContent in
                guard case .modified(_, let nestedModifiers) = nextContent else {
                    return
                }

                array = nestedModifiers + array
            } + modifiers
        )
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
            case .modifiers(let lhs) = contentOutput.storage,
            case .modifiers(let rhs) = modifierOutput.storage
        else {
            preconditionFailure("RichStringModifier types \(type(of: content)), \(type(of: modifier)) must produce modifier output")
        }

        return .init(lhs + rhs)
    }
}
