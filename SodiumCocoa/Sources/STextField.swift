import UIKit
import SodiumSwift



/**
 ## Sodium TextField
 
 - Author: Andrew Bradnan
 - Date: 5/20/16
 - Copyright: © 2016 Whirlygig Ventures. All rights reserved.
 */
open class STextField : UITextField {
    var refs: MemReferences?
    var pathLayer: CAShapeLayer
    
    open var underlineColor : CGColor? {
        get {
            return self.pathLayer.strokeColor
        }
        set (value) {
            self.pathLayer.strokeColor = value
        }
    }
    
    open var csText = CellSink<String>("") {
        didSet{
            self.userChanges = csText.stream()
        }
    }
    weak var userChanges: SodiumSwift.Stream<String>?
    fileprivate var l: Listener?
    
    open var cText = Cell<String>(value: "") {
        didSet{
            self.l = Operational.updates(cText).listen(self.refs) { t in
                gui { self.text = t }
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
    
    public convenience init(s: SodiumSwift.Stream<String>, text: String, refs: MemReferences? = nil) {
        self.init(frame: CGRect.zero, text: text, refs: refs)
    }
    
    public convenience init(text: String, refs: MemReferences? = nil) {
        self.init(frame: CGRect.zero, text: text, refs: refs)
    }
    
    init(frame: CGRect, text: String, refs: MemReferences? = nil) {
        self.csText = CellSink<String>(text, refs: refs)
        self.cText = Cell<String>(value: text, refs: refs)
        self.refs = refs
        if let r = self.refs { r.addRef() }
        
        self.pathLayer = CAShapeLayer()
        super.init(frame: frame)

        self.l = self.listen()
        self.text = text
        
        // Add a "textFieldDidChange" notification method to the text field control.
        self.addTarget(self, action: #selector(STextField.textFieldDidChange), for:UIControlEvents.editingChanged)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        self.pathLayer = CAShapeLayer()
        super.init(coder: aDecoder)

        self.csText         = CellSink<String>("", refs: self.refs)
        self.cText          = Cell<String>(value: "", refs: self.refs)
        self.userChanges    = csText.stream() // didSet doesn't work in init()
        self.l              = self.listen()

        // Add a "textFieldDidChange" notification method to the text field control.
        self.addTarget(self, action: #selector(STextField.textFieldDidChange), for:UIControlEvents.editingChanged)
    }

    deinit {
        if let r = self.refs { r.release() }
    }
    
    open func setupUnderline() {
        // setup underline
        let path: UIBezierPath = UIBezierPath()
        path.move(to: CGPoint(x: 0.0, y: self.frame.size.height))
        path.addLine(to: CGPoint(x: self.frame.size.width, y: self.frame.size.height))
        
        self.pathLayer.frame = self.bounds
        self.pathLayer.path = path.cgPath
        self.pathLayer.strokeColor = UIColor.clear.cgColor
        self.pathLayer.fillColor = nil
        self.pathLayer.lineWidth = 2.0 * UIScreen.main.scale
        self.pathLayer.lineJoin = kCALineJoinBevel
        self.pathLayer.strokeEnd = 1.0
        
        //Add the layer to your view's layer
        self.layer.addSublayer(self.pathLayer)
    }
    
    fileprivate var hiddenListener: Listener?
    open var hiddenState = Cell<Bool>(value: false) {
        didSet {
            self.hiddenListener = Operational.updates(hiddenState).listen { hidden in
                gui { self.isHidden = hidden }
            }
        }
    }

    fileprivate func listen() -> Listener? {
        return self.userChanges?.listen(self.refs) { [weak self] text in self!.text = text }
    }
    
    @objc fileprivate func textFieldDidChange(_ sender: UITextField) {
        self.csText.send(sender.text!)
    }
}
