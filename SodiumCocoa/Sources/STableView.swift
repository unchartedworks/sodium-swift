//
//  STableView.swift
//  Sodium
//
//  Created by Liang on 20/02/2018.
//  Copyright © 2018 UnchartedWorks. All rights reserved.
//

import UIKit
import SodiumSwift

open class STableView: UITableView {
    var refs: MemReferences?

    open var items: [SectionModel<Any, Any>] = []
    open var csItems = CellSink<[SectionModel<Any, Any>]>([]) {
        didSet {
            self.userChanges = csItems.stream()
        }
    }
    
    open var select = StreamSink<IndexPath>()
    open var delete = StreamSink<IndexPath>()
    open var insert = StreamSink<IndexPath>()
    open var none   = StreamSink<IndexPath>()

    weak var userChanges: SodiumSwift.Stream<[SectionModel<Any, Any>]>?
    fileprivate var l: Listener?
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.csItems = CellSink<[SectionModel<Any, Any>]>(self.items, refs: self.refs)
        self.userChanges     = csItems.stream()
        self.l               = self.listen()
        self.delegate        = self
        self.dataSource      = self
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

extension STableView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        select.send(indexPath)
    }
    
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            delete.send(indexPath)
        case .insert:
            insert.send(indexPath)
        case .none:
            none.send(indexPath)
        }
    }
}

//MARK: Data Source
extension STableView: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = (self.items[indexPath.section].items[indexPath.row] as! String)
        return cell
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items[section].items.count
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return self.items.count
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.items[section].section as? String
    }
}

public struct SectionModel<Section, ItemType> {
    public var section: Section
    public var items: [ItemType]
    
    public init(section: Section, items: [ItemType]) {
        self.section = section
        self.items   = items
    }
}

extension SectionModel: CustomStringConvertible {
    public var description: String {
        return "\(self.section) > \(items)"
    }
}

extension SectionModel {
    public init(original: SectionModel<Section, ItemType>, items: [ItemType]) {
        self.section = original.section
        self.items   = items
    }
}
