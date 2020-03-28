# CommonMarkAttributedString

![CI][ci badge]
[![Documentation][documentation badge]][documentation]

**CommonMarkAttributedString** is a Swift package that lets you
create attributed strings using familiar CommonMark (Markdown) syntax.
It's built on top of [CommonMark][commonmark],
which is fully compliant with the [CommonMark Spec][commonmark spec].

## Supported Platforms

- macOS 10.10+
- Mac Catalyst 13.0+
- iOS 9.0+
- tvOS 9.0+

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

![Result][screenshot-1]

You can also use CommonMarkAttributedString
to create attributed strings that have multiple paragraphs,
with links, headings, lists, and images.

```swift
let commonmark = #"""
# [Universal Declaration of Human Rights][uhdr]

## Article 1.

All human beings are born free and equal in dignity and rights.
They are endowed with reason and conscience
and should act towards one another in a spirit of brotherhood.

[uhdr]: https://www.un.org/en/universal-declaration-human-rights/ "View full version"
"""#

let attributes: [NSAttributedString.Key: Any] = [
    .font: NSFont.systemFont(ofSize: NSFont.systemFontSize),
    .foregroundColor: NSColor.textColor,
    .backgroundColor: NSColor.textBackgroundColor,
]

let attributedString = try NSAttributedString(commonmark: commonmark, attributes: attributes)
```

![Result][screenshot-2]

## Supported CommonMark Elements

- [x] `Code`
- [x] _Emphasis_
- [x] [Link](#) _(inline links, link references, and autolinks)_
- [x] **Strong**
- [x] > Block Quotes
- [x] Headings
- [x] Raw `<html>` <sup>*</sup>
- [x] • Bulleted Lists <sup>*</sup>
- [x] 1. Ordered Lists <sup>*</sup>
- [x] 🖼 Images <sup>*</sup>

### Raw Inline HTML

According to the [CommonMark specification][commonmark spec § 6.8],
each inline HTML tag is considered its own element.
That is to say,
CommonMark doesn't have a concept of opening or closing tags.
So, for example,
the CommonMark string `<span style="color: red;">hello</span>`
corresponds to a paragraph block containing three inline elements:

- `Code` (`<span style="color: red;">`)
- `Text` (`hello`)
- `Code` (`</span>`)

Parsing and rendering HTML is out of scope for this library,
so whenever CommonMarkAttributedString receives text containing any HTML,
it falls back on `NSAttributedString`'s built-in HTML initializer.

### Bulleted and Ordered Lists

CommonMarkAttributedString renders bulleted and ordered lists
using conventional indentation and markers ---
disc (•), circle(◦), and square (■) 
for unordered lists
and
decimal numerals (1.), lowercase roman numerals (i.), and lowercase letters (a.)
for ordered lists.

- Level 1
    - Level 2
        - Level 3

<hr/>

1. Level 1
    1. Level 2
        1. Level 3


### Images

Attributed strings can embed images using the `NSTextAttachment` class.
However,
there's no built-in way to load images asynchronously.
Rather than load images synchronously as they're encountered in CommonMark text,
CommonMarkAttributedString provides an optional `attachments` parameter
that you can use to associate existing text attachments
with image URL strings.

```swift
let commonmark = "![](https://example.com/image.png)"

let attachments: [String: NSTextAttachment] = [
    "https://example.com/image.png": NSTextAttachment(data: <#...#>, ofType: "public.png")
]

let attributedString = try NSAttributedString(commonmark: commonmark, attributes: attributes, attachments: attachments)
```


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
        from: "0.1.0"
    ),
  ]
)
```

Then run the `swift build` command to build your project.

## License

MIT

## Contact

Mattt ([@mattt](https://twitter.com/mattt))

[commonmark]: https://github.com/SwiftDocOrg/CommonMark
[commonmark spec]: https://spec.commonmark.org
[commonmark spec § 6.8]: https://spec.commonmark.org/0.29/#raw-html

[screenshot-1]: https://user-images.githubusercontent.com/7659/76089806-35fcf400-5f6f-11ea-934c-b676b6af99cf.png
[screenshot-2]: https://user-images.githubusercontent.com/7659/76094168-fe924580-5f76-11ea-821b-aa2f07c0e21b.png

[ci badge]: https://github.com/mattt/CommonMarkAttributedString/workflows/CI/badge.svg
[documentation badge]: https://github.com/mattt/CommonMarkAttributedString/workflows/Documentation/badge.svg
[documentation]: https://github.com/mattt/CommonMarkAttributedString/wiki
