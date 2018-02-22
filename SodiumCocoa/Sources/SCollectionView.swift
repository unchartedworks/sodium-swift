//
//  SCollectionView.swift
//  Sodium
//
//  Created by Liang on 20/02/2018.
//  Copyright © 2018 UnchartedWorks. All rights reserved.
//

import UIKit
import SodiumSwift

open class SCollectionView: UICollectionView {
    var refs: MemReferences?

    open var items: [SectionModel<Any, Any>] = []
    open var csItems = CellSink<[SectionModel<Any, Any>]>([]) {
        didSet {
            self.userChanges = csItems.stream()
        }
    }
    
    weak var userChanges: SodiumSwift.Stream<[SectionModel<Any, Any>]>?
    fileprivate var l: Listener?
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.csItems      = CellSink<[SectionModel<Any, Any>]>(self.items, refs: self.refs)
        self.userChanges  = csItems.stream()
        self.l            = self.listen()
    }
    
    deinit {
        if let r = self.refs { r.release() }
    }
    
    fileprivate func listen() -> Listener? {
        return self.userChanges?.listen(self.refs) { [weak self] xs in
            self?.items = xs
            self?.reloadData()
        }
    }
}
