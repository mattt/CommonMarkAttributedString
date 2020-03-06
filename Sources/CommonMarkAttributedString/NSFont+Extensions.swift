#if canImport(AppKit)

import class AppKit.NSFont
import class AppKit.NSFontDescriptor


extension NSFont {
    func addingSymbolicTraits(_ traits: NSFontDescriptor.SymbolicTraits) -> NSFont? {
        var symbolicTraits = fontDescriptor.symbolicTraits
        symbolicTraits.insert(traits)
        return NSFont(descriptor: fontDescriptor.withSymbolicTraits(symbolicTraits), size: pointSize)
    }
    
    var monospaced: NSFont? {
        var symbolicTraits = fontDescriptor.symbolicTraits
        symbolicTraits.insert(.monoSpace)
        
        guard let fontDescriptor = NSFont.userFixedPitchFont(ofSize: pointSize)?.fontDescriptor.withSymbolicTraits(symbolicTraits) else { return nil }
        
        return NSFont(descriptor: fontDescriptor, size: pointSize)
    }
}

#endif
