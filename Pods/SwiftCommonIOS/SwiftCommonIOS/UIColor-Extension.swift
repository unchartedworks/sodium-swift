/**
 # UIColor-Extension.swift
## SwiftCommonIOS
 
 - Author: Andrew Bradnan
 - Date: 5/24/16
 - Copyright: Copyright © 2016 Belkin. All rights reserved.
 */

import Foundation

extension UIColor {
    
    /**
     Create a UIColor from web components.
     
     '''
     let c = UIColor.fromHex(0x223344)
     '''
     */
    public class func fromHex(_ rgbValue:UInt32, alpha:Double = 1.0) -> UIColor {
        
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
    
    /**
     Get HSBA components (Hue, Saturation, Brightness, Alpha)
     
     '''
     let (h,s,b,a) = color.hsba
     '''
    */
    public var hsba:(h: CGFloat, s: CGFloat,b: CGFloat,a: CGFloat) {
        var hsba:(h: CGFloat, s: CGFloat,b: CGFloat,a: CGFloat) = (0,0,0,0)
        self.getHue(&(hsba.h), saturation: &(hsba.s), brightness: &(hsba.b), alpha: &(hsba.a))
        return hsba
    }
    
    /// Darken anything over this brightness.
    public func darken(_ b: CGFloat) -> UIColor {
        let hsba = self.hsba
        
        if hsba.b > b {
            return UIColor(hue: hsba.h, saturation: hsba.s, brightness: b, alpha: hsba.a)
        }
        return self
    }
}
