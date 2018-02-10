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

        let first = CGRect(x:10, y:60, width:200, height:50)
        let second = CGRect(x:10, y:120, width:200, height:50)
        
        let onegai = NAButton("Onegai shimasu")
        onegai.frame = first
        onegai.setTitle("hello", for: UIControlState.normal)
        onegai.setTitleColor(UIColor.blue, for: .normal)
        
        let btnFrame = CGRect(x:100, y:300, width:200, height:50)
        let btn = UIButton(type: UIButtonType.system)
        btn.addTarget(self, action: #selector(Example24.action), for: UIControlEvents.touchUpInside)
        btn.setTitle("good", for: UIControlState.normal)
        btn.frame = btnFrame
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.lightGray.cgColor
//        btn.setTitleColor(UIColor.black, for: .normal)
//        btn.isA
        self.view.addSubview(btn)

        let thanks = NAButton("Thank you")
        thanks.frame = second
        thanks.setTitleColor(UIColor.blue, for: .normal)
        
        let sOnegai = onegai.clicked.map{ _ in "Onegai shimasu" }
        let sThanks = thanks.clicked.map{ _ in "Thank you" }
        let sCanned = sOnegai.orElse(sThanks)
        let txt = NATextField(s: sCanned, text: "")
        
        //self.view.addSubview(onegai)
        self.view.addSubview(thanks)
        self.view.addSubview(txt)
        
        let close = UIButton()
        close.frame = CGRect(x: 50, y: 130, width: 100, height: 30)
        close.setTitle("close", for: .normal)
        close.setTitleColor(UIColor.blue, for: .normal)
        close.addTarget(self, action: #selector(doclose), for: .touchUpInside)
        self.view.addSubview(close)
    }
    
    @objc func action(_ sender:UIButton!) {
        print("Button Clicked")
    }
    
    func doclose() {
        self.dismiss(animated: true, completion: nil)
    }
    
}
