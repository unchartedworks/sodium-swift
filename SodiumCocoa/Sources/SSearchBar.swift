//
//  SStringPicker.swift
//  Sodium
//
//  Created by Liang on 18/02/2018.
//  Copyright © 2018 UnchartedWorks. All rights reserved.
//

import UIKit
import SodiumSwift

open class SSearchBar: UISearchBar, UISearchBarDelegate {
    var refs: MemReferences?

    open var csText = CellSink<String>(String()) {
        didSet{
            self.userChanges = csText.stream()
        }
    }
    
    weak var userChanges: SodiumSwift.Stream<String>?
    fileprivate var l: Listener?
    public let tap: StreamSink<SodiumSwift.Unit>
    
    open var cText = Cell<String>(value: String()) {
        didSet{
            self.l = Operational.updates(cText).listen(self.refs) { t in
                gui { self.text = t }
            }
            
            Transaction.post{ _ in
                DispatchQueue.main.async {
                    self.text = self.cText.sample()
                }
            }
            
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        self.tap            = StreamSink<SodiumSwift.Unit>(refs: refs)
        super.init(coder: aDecoder)
        
        self.csText         = CellSink<String>(self.text ?? "", refs: self.refs)
        self.cText          = Cell<String>(value: self.text ?? "", refs: self.refs)
        self.userChanges    = csText.stream() // didSet doesn't work in init()
        self.l              = self.listen()
        self.delegate       = self
    }
    
    deinit {
        if let r = self.refs { r.release() }
    }
    
    fileprivate func listen() -> Listener? {
        return self.userChanges?.listen(self.refs) { [weak self] text in self!.text = text}
    }
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        csText.send(searchText)
    }
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        tap.send(Unit.value)
    }
}
