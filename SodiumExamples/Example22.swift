/**
 # Example23.swift
 ##  Sodium
 
 - Author: Andrew Bradnan
 - Date: 5/31/16
 - Copyright: Copyright © 2016 Whirlygig Ventures. All rights reserved.
 */

import UIKit
import SodiumCocoa
import SodiumSwift

class Example22 : UIViewController {
    
    var refs: MemReferences?

    override func viewDidLoad() {
        
        self.view.backgroundColor = UIColor.white

        let msg  = NATextField(text: "hello", refs: refs)
        msg.frame = CGRect(x:10, y:0, width:100, height:30)
        self.view.addSubview(msg)
        
        let reversed = msg.txt.map{ String($0.characters.reversed()) }
        
        let lbl = NALabel(txt: reversed, refs: refs)
        lbl.frame = CGRect(x:10, y:30, width:100, height:30)

        self.view.addSubview(lbl)

        let close = UIButton()
        close.frame = CGRect(x: 50, y: 130, width:100, height:30)
        close.setTitle("close", for: .normal)
        close.setTitleColor(UIColor.blue, for: .normal)
        close.addTarget(self, action: #selector(doclose), for: .touchUpInside)
        self.view.addSubview(close)
    }

    func doclose() {
        self.dismiss(animated: true, completion: nil)
    }

}
