/**
 # UILabel-Extension.swift
## SwiftCommonIOS
 
 - Author: Andrew Bradnan
 - Date: 5/24/16
 - Copyright: Copyright © 2016 Belkin. All rights reserved.
 */

import Foundation

extension UILabel {
    internal func doHide(_ hide: Bool) {
        self.isHidden = hide
        self.accessibilityElementsHidden = hide
        self.isEnabled = !hide
        self.isAccessibilityElement = !hide
    }
    
    /// proper hide() that works with accessibility (seealso: show())
    public func hide() {
        doHide(true)
    }
    
    /// proper show() that works with accessibility (seealso: hide())
    public func show() {
        doHide(false)
    }
}
