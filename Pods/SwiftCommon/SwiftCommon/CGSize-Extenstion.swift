/**
 # CGSize-Extension.swift
## SwiftCommon
 
 - Author: Andrew Bradnan
 - Date: 5/23/16
 - Copyright: © 2016 Whirlygig Ventures.  All rights reserved.
 */

import Foundation

extension CGSize {
    /// Swap height & width
    public func swap() -> CGSize {
        return CGSize(width: self.height, height: self.width)
    }
}
