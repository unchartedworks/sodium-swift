/**
 # NALabel.swift
 ##  Sodium
 
 - Author: Andrew Bradnan
 - Date: 5/31/16
 - Copyright:   Copyright © 2016 Whirlygig Ventures. All rights reserved.
 */

import UIKit
import SodiumSwift

open class SActivityIndicatorView: UIActivityIndicatorView {
    var refs: MemReferences?
    fileprivate var l: Listener?
    fileprivate var hiddenListener: Listener?
    
    open var hiddenState = Cell<Bool>(value: false) {
        didSet {
            self.hiddenListener = hiddenState.listen { hidden in
                gui { self.isHidden = hidden }
            }
        }
    }
    
    open var cAnimated : Cell<Bool> {
        didSet{
            self.l = Operational.updates(cAnimated).listen(self.refs) { animated in
                gui { animated ? self.startAnimating() : self.stopAnimating()}
            }
        }
    }
    
    //        didSet{
    //            self.l = Operational.updates(csAnimated).listen(self.refs) { animated in
    //                gui { animated ? self.startAnimating() : self.stopAnimating() }
    //            }
    //        }
    //    }
    
    //    public init(_ animated: Cell<Bool>, refs: MemReferences? = nil ) {
    //        self.refs = refs
    //        if let r = self.refs {
    //            r.addRef()
    //        }
    //        self.l              = self.listen()
    //    }
    
    required public init(coder aDecoder: NSCoder) {
        self.cAnimated   = Cell<Bool>(value: false, refs: nil)
        super.init(coder: aDecoder)
    }
    
    deinit {
        if let r = self.refs { r.release() }
    }
    
    open func removeNotify() {
        l?.unlisten();
    }
}


