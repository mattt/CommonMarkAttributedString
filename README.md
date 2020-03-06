# CommonMarkAttributedString

![CI][ci badge]
[![Documentation][documentation badge]][documentation]

**CommonMarkAttributedString** is a Swift package that lets you
create attributed strings using familiar CommonMark (Markdown) syntax.
It's built on top of [libcmark][cmark]
and fully compliant with the [CommonMark Spec][commonmark].

## Usage

```swift
import CommonMarkAttributedString

let commonmark = "A *bold* way to add __emphasis__ to your `code`"

let attributes: [NSAttributedString.Key: Any] = [
    .font: NSFont.systemFont(ofSize: 24.0),
    .foregroundColor: NSColor.systemBlue,
]

let attributedString = try NSAttributedString(commonmark: commonmark, attributes: attributes)
```

![Result][screenshot]

## Requirements

- Swift 5.1+

## Installation

### Swift Package Manager

Add the CommonMarkAttributedString package to your target dependencies in `Package.swift`:

```swift
import PackageDescription

let package = Package(
  name: "YourProject",
  dependencies: [
    .package(
        url: "https://github.com/mattt/CommonMarkAttributedString",
        from: "0.0.1"
    ),
  ]
)
```

Then run the `swift build` command to build your project.

## License

MIT

## Contact

Mattt ([@mattt](https://twitter.com/mattt))

[cmark]: https://github.com/commonmark/cmark
[commonmark]: https://commonmark.org
[screenshot]: https://user-images.githubusercontent.com/7659/76089806-35fcf400-5f6f-11ea-934c-b676b6af99cf.png

[ci badge]: https://github.com/mattt/CommonMarkAttributedString/workflows/CI/badge.svg
[documentation badge]: https://github.com/mattt/CommonMarkAttributedString/workflows/Documentation/badge.svg
[documentation]: https://github.com/mattt/CommonMarkAttributedString/wiki
