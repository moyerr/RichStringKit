# 💰 RichStringKit 🔡

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
  <source media="(prefers-color-scheme: dark)" srcset= images/rich-string-0-dark.png>
  <img width=400 alt="Text changing depending on mode. Light: 'So light!' Dark: 'So dark!'" src=images/rich-string-0-light.png>
</picture>


Creating this string with `NSAttributedString` might look something like this:

```Swift
let attributedString = NSMutableAttributedString(
    string: "For the love of Swift ",
    attributes: [.font: UIFont.systemFont(ofSize: 20)]
)

let strongAttributes: [NSAttributedString.Key: Any] = [
    .foregroundColor: UIColor.swift,
    .font: UIFont.systemFont(ofSize: 20, weight: .semibold)
]

if let swiftRange = attributedString.string.range(of: "Swift") {
    attributedString.addAttributes(
        strongAttributes,
        range: NSRange(swiftRange, in: attributedString.string)
    )
}

if let heartImage = UIImage(systemName: "swift") {
    let heartAttachment = NSTextAttachment(image: heartImage)
    let heartString = NSMutableAttributedString(attachment: heartAttachment)
    let range = heartString.string.startIndex ..< heartString.string.endIndex

    heartString.addAttributes(
        strongAttributes,
        range: NSRange(range, in: heartString.string)
    )

    attributedString.append(heartString)
}
```

Building the same string with `RichStringKit` looks like this:

```Swift
let richString = NSAttributedString {
    "For the love of "
    Group {
        "Swift"
        Attachment(systemName: "swift")
    }
    .foregroundColor(.swift)
    .font(.boldSystemFont(ofSize: 40))
}
```

## Documentation 📖

_Full documentation coming soon_

Until then, take a look at some [example usage](#usage-)

## Installation 💻

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

TODO
