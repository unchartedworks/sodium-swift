//
//  SSlider.swift
//  SodiumCocoa
//
//  Created by Liang on 19/02/2018.
//  Copyright © 2018 UnchartedWorks. All rights reserved.
//

import UIKit
import SodiumSwift

open class SSlider: UISlider {
    var refs: MemReferences?
    
    open var csValue = CellSink<Float>(0.0) {
        didSet{
            self.userChanges = csValue.stream()
        }
    }
    
    weak var userChanges: SodiumSwift.Stream<Float>?
    fileprivate var l: Listener?

    open var cValue = Cell<Float>(value: 0) {
        didSet{
            self.l = Operational.updates(cValue).listen(self.refs) { x in
                gui { self.value = x }
            }
            
            Transaction.post{ _ in
                DispatchQueue.main.async {
                    self.value = self.cValue.sample()
                }
            }
            
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.csValue        = CellSink<Float>(self.value, refs: self.refs)
        self.cValue         = Cell<Float>(value: self.value , refs: self.refs)
        self.userChanges    = csValue.stream() // didSet doesn't work in init()
        self.l              = self.listen()
        
        self.addTarget(self, action: #selector(SSlider.valueDidChange), for:UIControl.Event.valueChanged)
    }
    
    deinit {
        if let r = self.refs { r.release() }
    }
    
    fileprivate func listen() -> Listener? {
        return self.userChanges?.listen(self.refs) { [weak self] x in self?.value = x}
    }
    
    @objc fileprivate func valueDidChange(_ sender: SSlider) {
        self.csValue.send(sender.value)
    }
}
