import XCTest
import CommonMarkAttributedString

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

final class CommonMarkAttributedStringTests: XCTestCase {
    func testReadmeExample() throws {
        let commonmark = "A *bold* way to add __emphasis__ to your `code`"

        #if canImport(UIKit)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 24.0),
            .foregroundColor: UIColor.systemBlue
        ]
        #elseif canImport(AppKit)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: NSFont.systemFont(ofSize: 24.0),
            .foregroundColor: NSColor.systemBlue
        ]
        #endif

        let attributedString = try NSAttributedString(commonmark: commonmark, attributes: attributes)

        XCTAssertEqual(attributedString.string, "A bold way to add emphasis to your code")
    }

    func testUHDR() throws {
        let commonmark = #"""
        # [Universal Declaration of Human Rights][uhdr]

        ## Article 1.

        All human beings are born free and equal in dignity and rights.
        They are endowed with reason and conscience
        and should act towards one another in a spirit of brotherhood.

        [uhdr]: https://www.un.org/en/universal-declaration-human-rights/ "View full version"
        """#

        #if canImport(UIKit)
        var attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.preferredFont(forTextStyle: .body),
        ]
        if #available(iOS 13.0, macCatalyst 13.0, tvOS 13.0, *) {
            attributes[.foregroundColor] = UIColor.label
            #if os(iOS)
            attributes[.backgroundColor] = UIColor.systemBackground
            #endif
        } else {
            attributes[.foregroundColor] = UIColor.black
            attributes[.backgroundColor] = UIColor.white
        }
        #elseif canImport(AppKit)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: NSFont.systemFont(ofSize: NSFont.systemFontSize),
            .foregroundColor: NSColor.textColor,
            .backgroundColor: NSColor.textBackgroundColor
        ]
        #endif

        let attributedString = try NSAttributedString(commonmark: commonmark, attributes: attributes)

        XCTAssert(attributedString.string.starts(with: "Universal Declaration of Human Rights"))
    }
}
