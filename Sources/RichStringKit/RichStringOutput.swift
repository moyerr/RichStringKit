import Foundation

public struct RichStringOutput: Equatable {
    enum Modifier: Equatable {
        case backgroundColor(Color)
        case baselineOffset(Double)
        case font(Font)
        case foregroundColor(Color)
        case kern(Double)
        case link(URL)
        case strikethroughStyle(LineStyle)
        case underlineColor(Color)
        case underlineStyle(LineStyle)
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

    var content: Content {
        guard case .content(let c) = storage else {
            fatalError("Storage was not content")
        }

        return c
    }

    init(_ content: Content) {
        self.storage = .content(content)
    }

    init(_ modifier: Modifier) {
        self.storage = .modifier(modifier)
    }
}

extension RichStringOutput.Content {
    func reduce<Result>(
        into initialResult: Result,
        _ updateAccumulatingResult: (inout Result, Self) throws -> ()
    ) rethrows -> Result {
        var accumulator = initialResult
        try updateAccumulatingResult(&accumulator, self)

        switch self {
        case .modified(let content, _):
            accumulator = try content.reduce(into: accumulator, updateAccumulatingResult)
        case .sequence(let contents):
            for content in contents {
                accumulator = try content.reduce(into: accumulator, updateAccumulatingResult)
            }
        default:
            break
        }
        
        return accumulator
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

extension Formatted {
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
            case .modifier(let rhs) = gatherOutput(for: modifier).storage
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

extension Concatenation {
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

extension _RichStringModifier_Content {
    public func _makeOutput() -> RichStringOutput {
        switch storage {
        case .modifier(let mod): return mod._makeOutput()
        case .content(let con):  return con._makeOutput()
        }
    }
}

// MARK: RichStringModifier Default

extension RichStringModifier {
    public func _makeOutput() -> RichStringOutput {
        body(.init(self))._makeOutput()
    }
}

// MARK: RichStringModifier Primitives

extension ModifiedContent where Self: RichStringModifier {
    public func _makeOutput() -> RichStringOutput {
        let contentOutput = gatherOutput(for: content)
        let modifierOutput = gatherOutput(for: modifier)

        guard
            case .modifier(let lhs) = contentOutput.storage,
            case .modifier(let rhs) = modifierOutput.storage
        else {
            preconditionFailure("RichStringModifier types \(type(of: content)), \(type(of: modifier)) must produce modifier output")
        }

        return .init(.combined(lhs, rhs))
    }
}

private func gatherOutput<Input>(
    for input: Input
) -> RichStringOutput where Input: RichStringModifier {
    if Input.Body.self == Never.self {
        return primitiveOutput(for: input)
    } else {
        return composedOutput(for: input)
    }
}

private func primitiveOutput<Input>(
    for input: Input
) -> RichStringOutput where Input: RichStringModifier {
    input._makeOutput()
}

private func composedOutput<Input>(
    for input: Input
) -> RichStringOutput where Input: RichStringModifier {
    // Pass an empty string just to run the body and get type info
    let output = input
        .body(.init(EmptyString()))
        ._makeOutput()

    guard
        case .content(let modifiedContent) = output.storage,
        case .modified(let content, let modifier) = modifiedContent
    else {
        preconditionFailure("we done fucked up: \(output)")
    }

    let reduced = reduceModifiers(content, modifier)

    return .init(reduced)
}

func reduceModifiers(
    _ content: RichStringOutput.Content,
    _ modifier: RichStringOutput.Modifier
) -> RichStringOutput.Modifier {
    switch content {
    case .modified(let nestedContent, let nestedModifier):
        return .combined(
            reduceModifiers(nestedContent, nestedModifier),
            modifier
        )
    default:
        return modifier
    }
}
