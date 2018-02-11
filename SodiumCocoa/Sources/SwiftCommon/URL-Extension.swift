/**
 # URL-Extension.swift
## SwiftCommon
 
 - Author: Andrew Bradnan
 - Date: 7/8/16
 - Copyright: © 2016 Whirlygig Ventures.  All rights reserved.
 */

import Foundation

extension URL {
    func ensureTrailingSlash() -> URL {
        if self.path.length > 0 && !self.absoluteString.hasSuffix("/") {
            return self.appendingPathComponent("")
        }
        return self
    }
}
