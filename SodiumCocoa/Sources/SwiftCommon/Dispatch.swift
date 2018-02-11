/**
 # Dispatch.swift
## SwiftCommon

 - Author: Andrew Bradnan
 - Date: 5/23/16
 - Copyright: © 2016 Whirlygig Ventures.  All rights reserved.
*/
import Foundation

public typealias Block = () -> Void

public func secondsFromNow(_ secs: Double) -> DispatchTime {
    let nanos = DispatchTime.now().rawValue + UInt64(secs * Double(NSEC_PER_SEC))
    
    return DispatchTime(uptimeNanoseconds: nanos)
}

/**
 Run this `Block` in N seconds (on the main queue).
 
 - Parameter secs: seconds from now.
 - Parameter block: closure to run.
 */
public func dispatch_after(_ secs: Double, block: @escaping Block) {
    DispatchQueue.main.asyncAfter(deadline: secondsFromNow(secs), execute: block)
}

/**
 Be sure and run on the main UI thread.and
 
 - Parameter block: the code to run.
 */
public func gui(_ block: @escaping Block) {
    if Thread.isMainThread {
        block()
    } else {
        DispatchQueue.main.async {
            block()
        }
    }
}
