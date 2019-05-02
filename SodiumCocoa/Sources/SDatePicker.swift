//
//  SDatePicker.swift
//  Sodium
//
//  Created by Liang on 18/02/2018.
//  Copyright © 2018 UnchartedWorks. All rights reserved.
//

import UIKit
import SodiumSwift

open class SDatePicker: UIDatePicker {
    var refs: MemReferences?

    open var csDate = CellSink<Date>(Date()) {
        didSet{
            self.userChanges = csDate.stream()
        }
    }
    weak var userChanges: SodiumSwift.Stream<Date>?
    fileprivate var l: Listener?

    open var cDate = Cell<Date>(value: Date()) {
        didSet{
            self.l = Operational.updates(cDate).listen(self.refs) { t in
                gui { self.date = t }
            }
            
            Transaction.post{ _ in
                DispatchQueue.main.async {
                    self.date = self.cDate.sample()
                }
            }
            
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.csDate         = CellSink<Date>(Date(), refs: self.refs)
        self.cDate          = Cell<Date>(value: Date(), refs: self.refs)
        self.userChanges    = csDate.stream() // didSet doesn't work in init()
        self.l              = self.listen()
        
        self.addTarget(self, action: #selector(SDatePicker.dateDidChange), for:UIControl.Event.valueChanged)
    }
    
    deinit {
        if let r = self.refs { r.release() }
    }
    
    fileprivate func listen() -> Listener? {
        return self.userChanges?.listen(self.refs) { [weak self] date in self!.date = date}
    }
    
    @objc fileprivate func dateDidChange(_ sender: Any) {
        let datePicker = sender as! UIDatePicker
        csDate.send(datePicker.date)
    }
}
