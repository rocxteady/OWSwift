//
//  Image+Mock+Mock.swift
//
//
//  Created by Ulaş Sancak on 18.10.2023.
//

#if canImport(UIKit)
import UIKit.UIImage

extension UIImage {
    static var mockData: Data {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!.pngData()!
    }
}

#elseif canImport(AppKit)
import AppKit.NSImage

extension NSImage {
    static var mockData: Data {
        let rect: NSRect = .init(origin: .zero, size: .init(width: 1, height: 1))
        let image = NSImage(size: rect.size)
        image.lockFocus()
        let color = NSColor.clear
        color.drawSwatch(in: rect)
        image.unlockFocus()
        return image.tiffRepresentation!
    }
}
#endif

struct MockImageDataGenerator {
    static func generate() -> Data {
        #if canImport(UIKit)
        UIImage.mockData
        #elseif canImport(AppKit)
        NSImage.mockData
        #endif
    }
}
