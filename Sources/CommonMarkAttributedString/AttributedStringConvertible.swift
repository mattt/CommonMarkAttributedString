import Foundation

#if canImport(UIKit)
import class UIKit.NSTextAttachment
#elseif canImport(AppKit)
import class AppKit.NSTextAttachment
#endif

protocol AttributedStringConvertible {
    func attributes(with attributes: [NSAttributedString.Key: Any]) -> [NSAttributedString.Key: Any]
    func attributedString(attributes: [NSAttributedString.Key: Any], attachments: [String: NSTextAttachment]) throws -> NSAttributedString
}
