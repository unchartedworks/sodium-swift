/**
 # CGRect-Extension.swift
## SwiftCommon
 
 - Author: Andrew Bradnan
 - Date: 5/24/16
 - Copyright: © 2016 Whirlygig Ventures.  All rights reserved.
 */

import Foundation

extension CGRect {
    public var bottom: CGFloat { return self.origin.y + self.size.height }
}
