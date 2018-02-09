/**
 # Array-Extension.swift
## SwiftCommon
 
 - Author: Andrew Bradnan
 - Date: 5/24/16
 - Copyright: © 2016 Whirlygig Ventures.  All rights reserved.
 */

import Foundation

extension Sequence {
    /**
     Find the index of element using a predicate
     
     - Parameter predicate: This Element?
     - Returns: Index or .None
    */
    public func indexOf(_ predicate: (Self.Iterator.Element) -> Bool) -> Int? {
        for (idx, element) in self.enumerated() {
            if predicate(element) {
                return idx
            }
        }
        return nil
    }
}

extension Sequence where Iterator.Element : Equatable {
    
    /**
     Find the index of Equatable element.
     
     - Parameter e: The element to search for
     - Returns: Index or .None
     */
    public func indexOf(_ e: Iterator.Element) -> Int? {
        for (idx, element) in self.enumerated() {
            if element == e {
                return idx
            }
        }
        return nil
    }
    
    /**
     Remove the Equatable element.
     
     - Parameter e: The element to search for
     - Returns: new array minus the element
     */
    public func remove(_ e: Iterator.Element) ->  [Self.Iterator.Element] {
        return self.filter { e != $0 }
    }
}
