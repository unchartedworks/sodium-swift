//
//  SButton.swift
//  SodiumCoca
//
//  Created by Andrew Bradnan on 5/20/16.
//  Copyright © 2016 Whirlygig Ventures. All rights reserved.
//

import UIKit
import SodiumSwift

open class SButton : UIButton {
    public typealias Title = (String, UIControlState)
    fileprivate let empty : Title = ("", UIControlState())

    fileprivate var enabledListener: Listener?
    open var cEnabledState = AnyCell<Bool>(Cell<Bool>(value: false)) {
        didSet {
            self.enabledListener = cEnabledState.listen { enabled in
                gui {
                    // we set disabled text color in init
                    self.isEnabled = enabled
                }
            }
        }
    }

    fileprivate var hiddenListener: Listener?
    open var cHiddenState = AnyCell<Bool>(Cell<Bool>(value: false)) {
        didSet {
            self.hiddenListener = cHiddenState.listen { hidden in
                gui { self.isHidden = hidden }
            }
        }
    }

    let refs: MemReferences?
    fileprivate var txtListener: Listener?

    open let tap: StreamSink<SodiumSwift.Unit>
    open var text: Title {
        get {
            return cTitle.sample()
        }
        set(value) {
            Transaction.run { trans in
                Transaction.cantBeInSend()
                self.cTitle.stream().send(trans, a: value)
            }
        }
    }

    open var cTitle: Cell<Title> {
        didSet {
            self.txtListener = Operational.updates(cTitle).listen(self.refs) { txt in
                gui { self.setTitle(txt.0, for: txt.1) }
            }
        }
    }


    public convenience init(_ txt: Cell<Title>, refs: MemReferences? = nil) {
        self.init(type: .system, refs: refs)

        self.cTitle = txt
        self.layer.borderColor = UIColor.red.cgColor
        self.sizeToFit()
        self.addTarget(self, action: #selector(SButton.onTapped), for: .touchUpInside)
    }

    public convenience init(_ text: String, refs: MemReferences? = nil) {
        self.init(type: .system, refs: refs)

        self.titleLabel!.text = text
        self.layer.borderColor = UIColor.red.cgColor
        self.sizeToFit()
        self.addTarget(self, action: #selector(SButton.onTapped), for: .touchUpInside)
    }

    init(type: UIButtonType, refs: MemReferences? = nil) {
        self.tap = StreamSink<SodiumSwift.Unit>(refs: refs)
        self.refs = refs
        if let r = self.refs {
            r.addRef()
        }
        self.cTitle = Cell<Title>(value: empty, refs: refs)
        super.init(frame: CGRect(x:0,y:0,width:10,height:10))
    }

    required public init?(coder aDecoder: NSCoder) {
        self.refs = nil
        self.tap = StreamSink<SodiumSwift.Unit>(refs: nil)
        self.cTitle = Cell<Title>(value: empty, refs: nil)
        super.init(coder: aDecoder)

        self.setTitleColor(UIColor.lightGray, for: .disabled)
        self.addTarget(self, action: #selector(SButton.onTapped), for: .touchUpInside)
    }

    deinit {
        if let r = self.refs { r.release() }
    }

    @objc func onTapped() {
        tap.send(Unit.value)
    }

}
