//
//  SImageView.swift
//  Sodium
//
//  Created by Liang on 18/02/2018.
//  Copyright © 2018 UnchartedWorks. All rights reserved.
//

import UIKit
import SodiumSwift

open class SImageView: UIImageView {
    var refs: MemReferences?
    
    fileprivate var hiddenListener: Listener?
    open var hiddenState = Cell<Bool>(value: false) {
        didSet {
            self.hiddenListener = hiddenState.listen { hidden in
                gui { self.isHidden = hidden }
            }
        }
    }
    
    open var cImage: Cell<UIImage> {
        didSet{
            self.l = Operational.updates(cImage).listen(self.refs) { image in
                gui { self.image = image }
            }
            
            // Set the text at the end of the transaction so SLabel works
            // with CellLoops.
            Transaction.post{ _ in
                DispatchQueue.main.async {
                    self.image = self.cImage.sample()
                }
            }
            
        }
    }
    
    public init(image: Cell<UIImage>, refs: MemReferences? = nil ) {
        self.cImage = image
        self.refs = refs
        if let r = self.refs {
            r.addRef()
        }
        super.init(frame: CGRect.zero)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        self.cImage = Cell<UIImage>(value: UIImage(), refs: nil)
        super.init(coder: aDecoder)
    }
    
    fileprivate var l: Listener?
    
    open func removeNotify() {
        l?.unlisten();
    }
    
}
