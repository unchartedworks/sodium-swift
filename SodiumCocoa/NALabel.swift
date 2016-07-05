/**
 # NALabel.swift
 ##  Sodium
 
 - Author: Andrew Bradnan
 - Date: 5/31/16
 - Copyright:   Copyright © 2016 Whirlygig Ventures. All rights reserved.
 */

import UIKit
import SodiumSwift
import SwiftCommon

public class NALabel : UILabel {
    var refs: MemReferences?

    public var txt: Cell<String> {
        didSet{
            self.l = Operational.updates(txt).listen ({ txt in
                gui() {
                    self.text = txt
                }
            }, refs: self.refs)
            
            // Set the text at the end of the transaction so SLabel works
            // with CellLoops.
            Transaction.post{ _ in
                dispatch_async(dispatch_get_main_queue()) {
                    self.text = self.txt.sample()
                }
            }
            
        }
    }
    
    public init(txt: Cell<String>, refs: MemReferences? = nil ) {
        self.txt = txt //Cell<String>(value: text, refs: refs)
        self.refs = refs
        if let r = self.refs {
            r.addRef()
        }
        super.init(frame: CGRectZero)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        self.txt = Cell<String>(value: "", refs: nil)
        super.init(coder: aDecoder)
    }
    
    private var l: Listener?
    
    public func removeNotify() {
        l?.unlisten();
    }
}

