//
//  SSegmentControl.swift
//  Sodium
//
//  Created by Liang on 22/02/2018.
//  Copyright © 2018 UnchartedWorks. All rights reserved.
//

import UIKit
import SodiumSwift

open class SSegmentedControl: UISegmentedControl {
    var refs: MemReferences?
    open var select = StreamSink<Int>()

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.addTarget(self, action: #selector(SSegmentedControl.valueDidChange), for:UIControlEvents.valueChanged)
    }
    
    deinit {
        if let r = self.refs { r.release() }
    }
    
    @objc fileprivate func valueDidChange(_ sender: SSegmentedControl) {
        self.select.send(sender.selectedSegmentIndex)
    }
}
