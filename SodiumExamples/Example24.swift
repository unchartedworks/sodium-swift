/**
 # Example24.swift
## Sodium
 
 - Author: Andrew Bradnan
 - Date: 6/1/16
 - Copyright: Copyright © 2016 Whirlygig Ventures. All rights reserved.
 */


import SodiumSwift
import SodiumCocoa
import UIKit

class Example24 : UIViewController {

    var refs: MemReferences?
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.white

        let first = CGRect(x:10, y:60, width:100, height:30)
        let second = CGRect(x:10, y:120, width:100, height:30)
        
        let onegai = NAButton("Onegai shimasu")
        onegai.frame = first
        onegai.setTitle("hello", for: UIControlState.normal)

        let thanks = NAButton("Thank you")
        thanks.frame = second
        let sOnegai = onegai.clicked.map{ _ in "Onegai shimasu" }
        let sThanks = thanks.clicked.map{ _ in "Thank you" }
        let sCanned = sOnegai.orElse(sThanks)
        let txt = NATextField(s: sCanned, text: "")
        
        self.view.addSubview(onegai)
        self.view.addSubview(thanks)
        self.view.addSubview(txt)
        
        let close = UIButton()
        close.frame = CGRect(x: 50, y: 130, width: 100, height: 30)
        close.setTitle("close", for: .normal)
        close.setTitleColor(UIColor.blue, for: .normal)
        close.addTarget(self, action: #selector(doclose), for: .touchUpInside)
        self.view.addSubview(close)
    }
    
    func doclose() {
        self.dismiss(animated: true, completion: nil)
    }
    
}
