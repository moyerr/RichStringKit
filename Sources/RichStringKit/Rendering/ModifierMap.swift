struct ModifierMap {
    struct RangedModifier {
        let range: Range<String.Index>
        let modifier: RichStringOutput.Modifier
    }

    var string: String = ""
    var rangedModifiers: [RangedModifier] = []
}

extension ModifierMap {
    init?(from richString: some RichString) {
        let output = richString._makeOutput()

        guard case .content(let content) = output.storage else { return nil }

        self = content.reduce(into: ModifierMap()) { modifierMap, content in
            let nextPart = content
                .reduce(into: "") { currentString, subContent in
                    switch subContent {
                    case .string(let string):
                        currentString += string
                    case .attachment:
                        // Object Replacement Character
                        currentString += "\u{FFFC}"
                    default:
                        return
                    }
                }

            let currentEndIndex = modifierMap.string.endIndex
            let updatedString = modifierMap.string + nextPart

            switch content {
            case .modified(_, let modifier):
                let updatedEndIndex = updatedString.endIndex
                let range = currentEndIndex ..< updatedEndIndex

                modifierMap.rangedModifiers.append(
                    RangedModifier(range: range, modifier: modifier)
                )
            case .string, .attachment:
                modifierMap.string = updatedString
            default:
                break
            }
        }
    }
}
