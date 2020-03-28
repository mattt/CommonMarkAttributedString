import Foundation
import struct CoreGraphics.CGFloat

#if canImport(UIKit)
import class UIKit.UIFont
import class UIKit.UIFontDescriptor

extension UIFont {
    func addingSymbolicTraits(_ traits: UIFontDescriptor.SymbolicTraits) -> UIFont? {
        var monospaceSymbolicTraits = fontDescriptor.symbolicTraits
        monospaceSymbolicTraits.insert(traits)
        guard let monospaceFontDescriptor = fontDescriptor.withSymbolicTraits(monospaceSymbolicTraits) else { return nil }

        return UIFont(descriptor: monospaceFontDescriptor, size: pointSize)
    }

    var traits: [UIFontDescriptor.TraitKey: Any] {
        return fontDescriptor.object(forKey: .traits) as? [UIFontDescriptor.TraitKey: Any]
            ?? [:]
    }

    var weight: UIFont.Weight {
        guard let number = traits[.weight] as? NSNumber else { return .regular }
        return UIFont.Weight(rawValue: CGFloat(number.doubleValue))
    }

    var monospaced: UIFont? {
        if #available(iOS 13.0, tvOS 13.0, watchOS 4.0, *) {
            return UIFont.monospacedSystemFont(ofSize: pointSize, weight: weight)
        } else {
            let monospaceFontDescriptor = fontDescriptor.addingAttributes([
                .family: "Menlo"
            ])

            return UIFont(descriptor: monospaceFontDescriptor, size: pointSize)
        }
    }
}
#endif
