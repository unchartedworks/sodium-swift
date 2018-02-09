/**
 # Event.swift
 ## SwiftCommon

 This is basically a C# event.  Delegates can only call back one sink.  This will mux.
 
 - Parameter T: the type of event to fire
 
 ```
 var mouseClick: Event<CGPoint>
 
 mouseClick.append("myfunc", .FireOnce) { t in ...}
 
 // source
 mouseClick.fire(location)
 ```
 - Author: Andrew Bradnan
 - Date: 6/7/16
 - Copyright: © 2016 Whirlygig Ventures.  All rights reserved.
*/

import Foundation

public class Event<T> {
    public typealias EventBlock = (T)->Void
    var events : [LambdaCallback<T>] = []
    var triggerType: EventTriggerType
    var param: T!
    
    public init (manual: Bool = false) {
        self.triggerType = .Manual(false)
    }
    
    func removeAll(keepCapacity: Bool) {
        events.removeAll(keepingCapacity: false)
    }
    
    public func append(dbg: String, life: EventLifeCycle, block: @escaping EventBlock) {
        switch self.triggerType {
        case .Manual(let eventSet) where eventSet == true:
            block(self.param)
            
            // if we aren't FireOnce, then add to the list of events
            if !life.contains(.FireOnce) {
                events.append(LambdaCallback<T>(dbg: dbg, block: block, life: life))
            }
        default:
            events.append(LambdaCallback<T>(dbg: dbg, block: block, life: life))
        }
    }
    
    public func fire(param: T) {
        if case .Manual(_) = self.triggerType {
            self.triggerType = .Manual(true)
            self.param = param
        }
        
        var fired: Bool = false
        self.events = notify(self.events, ffwd: false, fired: &fired, fire: { $0.fire(param: param) })
    }
}

public struct EventLifeCycle : OptionSet {
    public let rawValue: Int
    public init(rawValue: Int) { self.rawValue = rawValue }
    
    public static let Permanent = EventLifeCycle(rawValue: 1)
    public static let FireOnce = EventLifeCycle(rawValue: 2)
    public static let Skipable = EventLifeCycle(rawValue: 4)
}

protocol EventType {
    var lifeCycle: EventLifeCycle { get }
}

extension EventType {
    var isFireOnce: Bool { get { return self.lifeCycle.contains(.FireOnce) }}
    var isSkipable: Bool { get { return self.lifeCycle.contains(.Skipable) }}
}

func notify<C: Collection>(_ events: C, ffwd: Bool, fired: inout Bool, fire: (C.Iterator.Element)->Void) -> [C.Iterator.Element] where C.Iterator.Element : EventType {
    var rt: [C.Generator.Element] = []
    fired = false
    
    for e in events {
        if !ffwd || !e.isSkipable {
            fired = true
            fire(e)
        }
        if !e.isFireOnce {
            rt.append(e)
        }
    }
    return rt
}

protocol EventParamType : EventType {
    associatedtype Element
    func fire(param: Element)
}

class LambdaCallback<T> : EventParamType {
    let block : (T)->Void
    let lifeCycle : EventLifeCycle
    
    internal let dbg: String
    init(dbg: String, block: @escaping (T)->Void, life: EventLifeCycle)
    {
        self.dbg = dbg
        self.block = block
        self.lifeCycle = life
    }
    
    func fire(param: T) { block(param) }
}

enum EventTriggerType {
    case Auto
    case Manual(Bool)   // set or not
}
