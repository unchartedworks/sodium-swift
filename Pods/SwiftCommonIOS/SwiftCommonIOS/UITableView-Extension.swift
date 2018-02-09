/**
 # UITableView-Extension.swift
##
 
 - Author: Andrew Bradnan
 - Date: 8/16/16
 - Copyright: 
 */

import UIKit
import SwiftCommon

extension UITableView {
    public func mergeData<T: Hashable>(new: [T], old: [T]) {
        /**
         1. Delete sections
         2. Delete rows
         3. Reload sections
         4. Reload rows
         5. Insert sections
         6. Insert rows
         */
        
        self.beginUpdates()
        
        let newSet = Set<T>(new)
        assert(new.count == newSet.count)
        
        let oldSet = Set<T>(old)
        assert(oldSet.count == old.count)
        
        let added = newSet.subtracting(oldSet)
        let removed = oldSet.subtracting(newSet)
        
        let removedRows = findIndexes(set: removed, array: old).sorted{ $0.row > $1.row }
        let addedRows = findIndexes(set: added, array: new).sorted{ $0.row < $1.row }
        
        self.deleteRows(at: removedRows, with: .top)
        self.insertRows(at: addedRows, with: .top)
        
        self.endUpdates()
    }
}

func findIndexes<T>(set: Set<T>, array: [T]) -> [IndexPath] {
    return set.flatMap{ ssid in
        if let idx = array.indexOf(ssid) {
            return IndexPath(row: idx, section: 0)
        }
        else {
            return nil
        }
    }
}
