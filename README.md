# 💰 RichStringKit 🔡

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fmoyerr%2FRichStringKit%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/moyerr/RichStringKit)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fmoyerr%2FRichStringKit%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/moyerr/RichStringKit)\
![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/moyerr/RichStringKit/swift.yml?branch=main&label=Build&logo=github)
![Updated](https://img.shields.io/github/last-commit/moyerr/RichStringKit/main?color=1f6feb&label=Updated)

RichStringKit is a declarative DSL for building rich text in Swift.

### Table of Contents

1. [Motivation 🧐](#motivation-)
2. [Documentation 📖](#documentation-)
3. [Installation 💻](#installation-)
4. [Usage 🔡](#usage-)

___

## Motivation 🧐

`NSAttributedString` is a powerful tool for creating rich text, but using it can be cumbersome and error-prone. Consider the following attributed text:

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/moyerr/RichStringKit/main/images/rich-string-0-dark.png">
  <img width=400 alt="Image of an attributed string that reads 'For the love of Swift' with the Swift programming language logo" src="https://raw.githubusercontent.com/moyerr/RichStringKit/main/images/rich-string-0-light.png">
</picture>


Creating this text with `NSAttributedString` might look something like this:

```Swift
let attributedString = NSMutableAttributedString(
    string: "For the love of Swift ",
    attributes: [.font: UIFont.systemFont(ofSize: 40)]
)

let strongAttributes: [NSAttributedString.Key: Any] = [
    .foregroundColor: UIColor.swift,
    .font: UIFont.boldSystemFont(ofSize: 40)
]

if let swiftLogo = UIImage(systemName: "swift") {
    let swiftLogoAttachment = NSTextAttachment(image: swiftLogo)
    let swiftLogoString = NSAttributedString(attachment: swiftLogoAttachment)

    attributedString.append(swiftLogoString)

    if let swiftRange = attributedString.string.range(of: "Swift") {
        let strongRange = swiftRange.lowerBound ..< attributedString.string.endIndex

        attributedString.addAttributes(
            strongAttributes,
            range: NSRange(strongRange, in: attributedString.string)
        )
    }
}
```

Creating the same text with `RichStringKit` looks like this:

```Swift
let richString = NSAttributedString {
    "For the love of "
    Group {
        "Swift "
        Attachment(systemName: "swift")
    }
    .foregroundColor(.swift)
    .font(.boldSystemFont(ofSize: 40))
}
```



## Documentation 📖

_Full documentation coming soon_

Until then, take a look at some [example usage](#usage-).

## Installation 💻

> RichStringKit requires Swift 5.7

### Swift Package Manager 📦

`RichStringKit` can be added as a package dependency via Xcode or in your `Package.swift` file.

#### Xcode

* File > Swift Packages > Add Package Dependency
* Add `https://github.com/moyerr/RichStringKit.git`
* Select "Up to Next Major" with `0.0.1`

#### Package.swift

Add the following value to the `dependencies` array:

```Swift
.package(url: "https://github.com/moyerr/RichStringKit", from: "0.0.1")
```

Include it as a dependency for one or more of your targets:

```Swift
.target(
  name: "<your-target>", 
  dependencies: [
    .product(name: "RichStringKit", package: "RichStringKit"),
  ]
)
```

## Usage 🔡

### Rich String Result Builder

The mechanism that enables RichStringKit's declarative DSL is the `RichStringBuilder`, which is a `@resultBuilder` similar to SwiftUI's [`ViewBuilder`](https://developer.apple.com/documentation/swiftui/viewbuilder). Closures, methods, and computed properties that return `some RichString` can be decorated with the `@RichStringBuilder` attribute to enable the DSL within them. For example:

```Swift
@RichStringBuilder
var richText: some RichString {
    "Underlined text"
        .underlineStyle(.single)
    
    " and "
    
    "strikethrough text"
        .strikethroughStyle(.single)
}
```

For more general information about Swift's result builder types, see [the Result Builder section of the Language Guide](https://docs.swift.org/swift-book/LanguageGuide/AdvancedOperators.html#ID630).

### Convenience Initializers

For convenience, `RichStringKit` provides initializers on `NSAttributedString`, `AttributedString`, and SwiftUI's `Text` view, all of which can either accept a `RichString` or a `@RichStringBuilder` closure. So you can start start using rich strings with your UI framework of choice.

Use the `NSAttributedString` initializers when working with UIKit:

```Swift
let label = UILabel()
label.attributedString = NSAttributedString {
    "UIKit"
        .font(.boldSystemFont(ofSize: 14))
    " is "
    "fun"
        .kern(4)
        .foregroundColor(.green)
}
```

Use the `Text` or `AttributedString` initializers when working with SwiftUI:

```Swift
struct ContentView: View {
    var body: some View {
        Text {
            "SwiftUI"
                .font(.boldSystemFont(ofSize: 14))
            " is also "
            "fun"
                .kern(4)
                .foregroundColor(.green)
        }
    }
}
```

### Modifiers

Style your text using the modifiers that `RichStringKit` provides, or by defining your own modifiers using the `RichStringModifier` protocol and the `modifier(_:)` method.

#### Built-in Modifiers

`RichStringKit` provides many modifiers for styling text, most of which map directly to attribute keys from `NSAttributedString.Key`. The modifier methods that are currently available are:

1. `.backgroundColor(_:)`
2. `.baselineOffset(_:)`
3. `.font(_:)`
4. `.foregroundColor(_:)` 
5. `.kern(_:)`
6. `.link(_:)`
7. `.strikethroughStyle(_:)`
8. `.underlineColor(_:)`
9. `.underlineStyle(_:)`

More attributes will be added soon (#7).

#### Combining Modifiers

Adopt the `RichStringModifier` protocol when you want to create a reusable modifier that you can apply to any `RichString`. The example below combines modifiers to create a new modifier that you can use to create highlighted text with a yellow background and a dark foreground:

```Swift
struct Highlight: RichStringModifier {
    func body(_ content: Content) -> some RichString {
        content
            .foregroundColor(.black)
            .backgroundColor(.yellow)
    }
}
```

You can apply `modifier(_:)` directly to a rich string, but a more common and idiomatic approach uses `modifier(_:)` to define an extension on `RichString` itself that incorporates the modifier:

```Swift
extension RichString {
    func highlighted() -> some RichString {
        modifier(Highlight())
    }
}
```

Then you can apply the highlight modifier to any rich string:

```Swift
var body: some RichText {
    "Draw the reader's attention to important information "
    "by applying a highlight"
        .highlighted()
}
```

### Advanced Usage

#### Formatted Strings

The `Format` type is provided to apply styling to formatted strings and their arguments independently.

```Swift
Format("For the love of %@") {
    Group {
        "Swift "
        Attachment(systemName: "swift")
    }
    .foregroundColor(.swift)
    .font(.boldSystemFont(ofSize: 40))
}
.font(.systemFont(ofSize: 40))
```

> **Note:** `RichStringKit` currently supports only the `%@` format specifier. If your use case requires more advanced formatting, you can apply the formatting before inserting it into the final format string. For example:
> ```Swift
> let receiptLine = AttributedString {
>     Format("Iced latte: %@") {
>         String(format: "%10.2f", -4.49)
>             .foregroundColor(.red)
>     }
> }
>
> // Iced latte:      -4.49
> ```
