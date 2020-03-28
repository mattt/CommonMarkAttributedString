import CommonMark
import Foundation
import class Foundation.NSAttributedString
import struct CoreGraphics.CGFloat

#if canImport(UIKit)
import class UIKit.UIFont
import class UIKit.NSTextAttachment
#elseif canImport(AppKit)
import class AppKit.NSFont
import class AppKit.NSTextAttachment
import class AppKit.NSTextList
#endif

// MARK: -

extension Node: AttributedStringConvertible {
    @objc func attributes(with attributes: [NSAttributedString.Key : Any]) -> [NSAttributedString.Key : Any] {
        return attributes
    }

    @objc func attributedString(attributes: [NSAttributedString.Key: Any], attachments: [String: NSTextAttachment]) throws -> NSAttributedString {
        let attributes = self.attributes(with: attributes)

        switch self {
        case is SoftLineBreak:
            return NSAttributedString(string: " ", attributes: attributes)
        case is HardLineBreak, is ThematicBreak:
            return NSAttributedString(string: "\u{2028}", attributes: attributes)
        case let literal as Literal:
            return NSAttributedString(string: literal.literal ?? "", attributes: attributes)
        case let container as ContainerOfBlocks:
            guard !container.children.contains(where: { $0 is HTMLBlock }) else {
                let html = try Document(container.description).render(format: .html)
                return try NSAttributedString(html: html, attributes: attributes) ?? NSAttributedString()
            }

            return try container.children.map { try $0.attributedString(attributes: attributes, attachments: attachments) }.joined(separator: "\u{2029}")
        case let container as ContainerOfInlineElements:
            guard !container.children.contains(where: { $0 is HTML }) else {
                let html = try Document(container.description).render(format: .html)
                return try NSAttributedString(html: html, attributes: attributes) ?? NSAttributedString()
            }

            return try container.children.map { try $0.attributedString(attributes: attributes, attachments: attachments) }.joined()
        case let list as List:
            return try list.children.enumerated().map { try $1.attributedString(in: list, at: $0, attributes: attributes, attachments: attachments) }.joined(separator: "\u{2029}")
        default:
            return NSAttributedString()
        }
    }
}

// MARK: Block Elements

extension BlockQuote {
    override func attributes(with attributes: [NSAttributedString.Key: Any]) -> [NSAttributedString.Key: Any] {
        var attributes = attributes

        #if canImport(UIKit)
        let font = attributes[.font] as? UIFont ?? UIFont.preferredFont(forTextStyle: .body)
        attributes[.font] = font.addingSymbolicTraits(.traitItalic)
        #elseif canImport(AppKit)
        let font = attributes[.font] as? NSFont ?? NSFont.systemFont(ofSize: NSFont.systemFontSize)
        attributes[.font] = font.addingSymbolicTraits(.italic)
        #endif

        return attributes
    }
}

extension CodeBlock {
    override func attributes(with attributes: [NSAttributedString.Key: Any]) -> [NSAttributedString.Key: Any] {
        var attributes = attributes

        #if canImport(UIKit)
        let font = attributes[.font] as? UIFont ?? UIFont.preferredFont(forTextStyle: .body)
        attributes[.font] = font.monospaced
        #elseif canImport(AppKit)
        let font = attributes[.font] as? NSFont ?? NSFont.systemFont(ofSize: NSFont.systemFontSize)
        attributes[.font] = font.monospaced
        #endif

        return attributes
    }
}

extension Heading {
    private var fontSizeMultiplier: CGFloat {
        switch level {
        case 1: return 2.00
        case 2: return 1.50
        case 3: return 1.17
        case 4: return 1.00
        case 5: return 0.83
        case 6: return 0.67
        default:
            return 1.00
        }
    }

    override func attributes(with attributes: [NSAttributedString.Key: Any]) -> [NSAttributedString.Key: Any] {
        var attributes = attributes

        #if canImport(UIKit)
        let font = attributes[.font] as? UIFont ?? UIFont.preferredFont(forTextStyle: .body)
        attributes[.font] = UIFont(name: font.fontName, size: font.pointSize * fontSizeMultiplier)?.addingSymbolicTraits(.traitBold)
        #elseif canImport(AppKit)
        let font = attributes[.font] as? NSFont ?? NSFont.systemFont(ofSize: NSFont.systemFontSize)
        attributes[.font] = NSFont(name: font.fontName, size: font.pointSize * fontSizeMultiplier)?.addingSymbolicTraits(.bold)
        #endif

        return attributes
    }
}

extension List {
    fileprivate var nestingLevel: Int {
        sequence(first: self) { $0.parent }.map { ($0 is List) ? 1 : 0}.reduce(0, +)
    }

    fileprivate var markerLevel: Int {
        sequence(first: self) { $0.parent }.map { ($0 as? List)?.kind == kind ? 1 : 0}.reduce(0, +)
    }
}

extension List.Item {
    private func ordinal(at position: Int) -> String {
        "\(position + 1)."
    }

    // TODO: Represent lists with NSTextList on macOS
    fileprivate func attributedString(in list: List, at position: Int, attributes: [NSAttributedString.Key: Any], attachments: [String: NSTextAttachment]) throws -> NSAttributedString {

        var delimiter: String = list.kind == .ordered ? "\(position + 1)." : "•"
        #if os(macOS) && canImport(AppKit)
        if #available(OSX 10.13, *) {
            let format: NSTextList.MarkerFormat
            switch (list.kind, list.markerLevel) {
            case (.bullet, 1): format = .disc
            case (.bullet, 2): format = .circle
            case (.bullet, _): format = .square
            case (.ordered, 1): format = .decimal
            case (.ordered, 2): format = .lowercaseAlpha
            case (.ordered, _): format = .lowercaseRoman
            }

            delimiter = NSTextList(markerFormat: format, options: 0).marker(forItemNumber: position + 1)
        }
        #endif

        let indentation = String(repeating: "\t", count: list.nestingLevel)

        let mutableAttributedString = NSMutableAttributedString(string: indentation + delimiter + " ", attributes: attributes)
        mutableAttributedString.append(try children.map { try $0.attributedString(attributes: attributes, attachments: attachments) }.joined(separator: "\u{2029}"))
        return mutableAttributedString
    }
}

// MARK: Inline Elements

extension Code {
    override func attributes(with attributes: [NSAttributedString.Key: Any]) -> [NSAttributedString.Key: Any] {
        var attributes = attributes

        #if canImport(UIKit)
        let font = attributes[.font] as? UIFont ?? UIFont.preferredFont(forTextStyle: .body)
        attributes[.font] = font.monospaced
        #elseif canImport(AppKit)
        let font = attributes[.font] as? NSFont ?? NSFont.systemFont(ofSize: NSFont.systemFontSize)
        attributes[.font] = font.monospaced
        #endif

        return attributes
    }
}

extension Emphasis {
    override func attributes(with attributes: [NSAttributedString.Key: Any]) -> [NSAttributedString.Key: Any] {
        var attributes = attributes

        #if canImport(UIKit)
        let font = attributes[.font] as? UIFont ?? UIFont.preferredFont(forTextStyle: .body)
        attributes[.font] = font.addingSymbolicTraits(.traitItalic)
        #elseif canImport(AppKit)
        let font = attributes[.font] as? NSFont ?? NSFont.systemFont(ofSize: NSFont.systemFontSize)
        attributes[.font] = font.addingSymbolicTraits(.italic)
        #endif
        

        return attributes
    }
}

extension Image {
    override func attributedString(attributes: [NSAttributedString.Key: Any], attachments: [String: NSTextAttachment]) throws -> NSAttributedString {
        guard let urlString = urlString else { return NSAttributedString() }
        guard let attachment = attachments[urlString] else { fatalError("missing attachment for \(urlString)") }
        return NSAttributedString(attachment: attachment)
    }
}

extension Link {
    override func attributes(with attributes: [NSAttributedString.Key: Any]) -> [NSAttributedString.Key: Any] {
        var attributes = attributes

        if let urlString = urlString, let url = URL(string: urlString) {
            attributes[.link] = url
        }

        #if os(macOS) && canImport(AppKit)
        if let title = title {
            attributes[.toolTip] = title
        }
        #endif

        return attributes
    }
}

extension Strong {
    override func attributes(with attributes: [NSAttributedString.Key: Any]) -> [NSAttributedString.Key: Any] {
        var attributes = attributes

        #if canImport(UIKit)
        let font = attributes[.font] as? UIFont ?? UIFont.preferredFont(forTextStyle: .body)
        attributes[.font] = font.addingSymbolicTraits(.traitBold)
        #elseif canImport(AppKit)
        let font = attributes[.font] as? NSFont ?? NSFont.systemFont(ofSize: NSFont.systemFontSize)
        attributes[.font] = font.addingSymbolicTraits(.bold)
        #endif

        return attributes
    }
}

extension Text {
    override func attributedString(attributes: [NSAttributedString.Key: Any], attachments: [String: NSTextAttachment]) throws -> NSAttributedString {
        return NSAttributedString(string: literal ?? "", attributes: attributes)
    }
}
