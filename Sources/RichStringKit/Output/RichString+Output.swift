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
            case .modifiers(let rhs) = modifier._makeOutput().storage
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

extension Format {
    public func _makeOutput() -> RichStringOutput {
        // 1. Convert each arg to its content
        let argContents = args.lazy.map { $0._makeOutput().content }

        // 2. Reduce args into their raw strings
        let rawArgs = argContents
            .map {
                $0.reduce(into: "") { result, nextContent in
                    guard case .string(let str) = nextContent else { return }
                    result += str
                }
            }

        // 3. Produce the formatted raw String
        let formatted = String(format: formatString, arguments: Array(rawArgs))

        // 4. Get the difference between formatted and formatString
        let difference = formatted.difference(from: formatString)

        // 5. Get the set of indices that were removed from the format string
        let removedIndices = Set(
            difference.removals
                .map { change in
                    guard case .remove(let offset, _, _) = change else {
                        preconditionFailure("Removals can only contain removals")
                    }

                    return formatString.index(formatString.startIndex, offsetBy: offset)
                }
        )

        // 6. Split the format string on the removed indices
        var pieces = formatString
            .split { removedIndices.contains($0) }

        // Special cases - if the removals were at the beginning or
        // or end of the string, add an empty subsequence in those
        // positions so we can interleave the args properly.

        let firstIndex = formatString.startIndex
        let lastIndex = formatString.index(before: formatString.endIndex)

        if removedIndices.contains(firstIndex) {
            pieces.insert(formatString[firstIndex ..< firstIndex], at: 0)
        }

        if removedIndices.contains(lastIndex) {
            pieces.append(formatString[lastIndex ..< lastIndex])
        }

        let content = pieces
            .map { substring -> any RichString in
                substring.isEmpty ? EmptyString() : String(substring)
            }
            .map { $0._makeOutput().content }

        // 7. Insert the arg contents between the split segments
        let contents = Array(content.interleaved(with: argContents))

        return .init(.sequence(contents))
    }
}

// MARK: _RichStringModifier_Content

extension _RichStringModifier_Content {
    public func _makeOutput() -> RichStringOutput {
        return content._makeOutput()
    }
}
