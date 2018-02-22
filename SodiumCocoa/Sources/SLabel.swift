/**
 # NALabel.swift
 ##  Sodium
 
 - Author: Andrew Bradnan
 - Date: 5/31/16
 - Copyright:   Copyright © 2016 Whirlygig Ventures. All rights reserved.
 */

import UIKit
import SodiumSwift


open class SLabel : UILabel {
    var refs: MemReferences?

    fileprivate var hiddenListener: Listener?
    open var hiddenState = Cell<Bool>(value: false) {
        didSet {
            self.hiddenListener = hiddenState.listen { hidden in
                gui { self.isHidden = hidden }
            }
        }
    }

    open var cText: Cell<String> {
        didSet{
            self.l = Operational.updates(cText).listen(self.refs) { txt in
                gui { self.text = txt }
            }
            
            // Set the text at the end of the transaction so SLabel works
            // with CellLoops.
            Transaction.post{ _ in
                DispatchQueue.main.async {
                    self.text = self.cText.sample()
                }
            }
            
        }
    }
    
    public init(txt: Cell<String>, refs: MemReferences? = nil ) {
        self.cText = txt //Cell<String>(value: text, refs: refs)
        self.refs = refs
        if let r = self.refs {
            r.addRef()
        }
        super.init(frame: CGRect.zero)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        self.cText = Cell<String>(value: "", refs: nil)
        super.init(coder: aDecoder)
    }
    
    fileprivate var l: Listener?
    
    open func removeNotify() {
        l?.unlisten();
    }
}


