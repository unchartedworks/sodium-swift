/**
 # UITableViewCell-Extension.swift
## SwiftCommonIOS
 
 - Author: Andrew Bradnan
 - Date: 5/24/16
 - Copyright: Copyright © 2016 Belkin. All rights reserved.
 */

import Foundation

extension UITableViewCell {
    /// Who's our parent view controller?
    public var parentViewController: UIViewController {
        get {
            let tv = self.superview!.superview as! UITableView
            let vc = tv.dataSource as! UIViewController
            return vc
        }
    }
    
    /// Who's our UITableView?
    public var tableView: UITableView {
        get {
            let tv = self.superview!.superview as! UITableView
            return tv
        }
    }
}