//
//  SSwitch.swift
//  Sodium
//
//  Created by Liang on 19/02/2018.
//  Copyright © 2018 UnchartedWorks. All rights reserved.
//

import UIKit
import SodiumSwift

open class SSwitch: UISwitch {
    var refs: MemReferences?
    
    open var csValue = CellSink<Bool>(true) {
        didSet{
            self.userChanges = csValue.stream()
        }
    }
    
    weak var userChanges: SodiumSwift.Stream<Bool>?
    fileprivate var l: Listener?

    open var cValue = Cell<Bool>(value: true) {
        didSet{
            self.l = Operational.updates(cValue).listen(self.refs) { x in
                gui { self.isOn = x }
            }
            
            Transaction.post{ _ in
                DispatchQueue.main.async {
                    self.isOn = self.cValue.sample()
                }
            }
            
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.csValue        = CellSink<Bool>(self.isOn, refs: self.refs)
        self.cValue         = Cell<Bool>(value: self.isOn, refs: self.refs)
        self.userChanges    = csValue.stream()
        self.l              = self.listen()
        
        self.addTarget(self, action: #selector(SSwitch.valueDidChange), for:UIControlEvents.valueChanged)
    }
    
    deinit {
        if let r = self.refs { r.release() }
    }
    
    fileprivate func listen() -> Listener? {
        return self.userChanges?.listen(self.refs) { [weak self] x in self?.isOn = x}
    }
    
    @objc fileprivate func valueDidChange(_ sender: SSwitch) {
        self.csValue.send(sender.isOn)
    }
}
