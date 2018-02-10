/**
 # Bool-Extension.swift
 ##  
 
 - Author: Andrew Bradnan
 - Date: 8/24/16
 - Copyright: © 2016 Whirlygig Ventures.  All rights reserved.
 */
import Foundation

extension Bool {
    public func toFloat() -> Float {
        return self ? 1.0 : 0.0
    }
    public func toFloat() -> CGFloat {
        return self ? 1.0 : 0.0
    }
}
