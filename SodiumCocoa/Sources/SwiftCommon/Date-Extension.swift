/**
 # Date-Extension.swift
## SwiftCommon
 
 - Copyright: © 2016 Whirlygig Ventures. All rights reserved.
 */

import Foundation

extension Date {
    public func hoursFrom(_ date:Date) -> Int {
        let c = Calendar.current
        
        return c.dateComponents([Calendar.Component.hour], from: date, to: self).hour!
    }
}
