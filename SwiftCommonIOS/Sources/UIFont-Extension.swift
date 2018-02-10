/**
 # UIFont-Extension.swift
## SwiftCommonIOS
 
 - Author: Andrew Bradnan
 - Date: 5/24/16
 - Copyright: Copyright © 2016 Belkin. All rights reserved.
 */

import Foundation

extension UIFont {
    /// Space above ascender
    public var topDescender: CGFloat { get { return ascender - lineHeight }}
}