/**
 # UIViewController-Extension.swift
## SwiftCommonIOS
 
 - Author: Andrew Bradnan
 - Date: 5/24/16
 - Copyright: Copyright © 2016 Belkin. All rights reserved.
 */

import Foundation
import SwiftCommon

extension UIViewController {
    /// Show error...
    public func showError(_ title: String, err: String, onOK: Block? = nil) {
        let alert = UIAlertController(title: title,
                                      message: err,
                                      preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in onOK?() })
        
        DispatchQueue.main.async(execute: {
            self.present(alert, animated: true, completion: nil)
        })
    }
}
