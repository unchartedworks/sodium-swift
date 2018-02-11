/**
 # UIImage-Extension.swift
## SwiftCommonIOS
 
 - Author: Andrew Bradnan
 - Date: 5/24/16
 - Copyright: Copyright © 2016 Belkin. All rights reserved.
 */

import Foundation

extension UIImage {
    
    /**
     Scale an UIImage up or down.
     
     - Parameter ratio: Ratio to scale by.
    */
    public func scaleBy(_ ratio: Double) -> UIImage {
        let fratio = CGFloat(ratio)
        let scaledSize = CGSize(width: self.size.width * fratio, height: self.size.height * fratio)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapBytesPerRow = Int(size.width * 4)
        
        // The output context.
        UIGraphicsBeginImageContext(scaledSize)
        let context = CGContext (data: nil,
                                             width: Int(scaledSize.width),
                                             height: Int(scaledSize.height),
                                             bitsPerComponent: 8,      // bits per component
            bytesPerRow: bitmapBytesPerRow,
            space: colorSpace,
            bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue).rawValue)
        
        // Scale.
        context?.scaleBy(x: fratio * 1.01, y: fratio * 1.01)
        self.draw(at: CGPoint.zero)
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return scaledImage!
    }
}
