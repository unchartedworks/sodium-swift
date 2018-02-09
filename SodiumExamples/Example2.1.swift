//
//  Example2.1.swift
//  Sodium
//
//  Created by Andrew Bradnan on 5/20/16.
//  Copyright © 2016 Whirlygig Ventures. All rights reserved.
//

import UIKit
import SodiumSwift
import SodiumCocoa

class Example21 : UIViewController {
 
    var refs: MemReferences?

    deinit {
        print ("Example21 deinit \(refs?.count())")
    }
    
    override func viewDidLoad() {
        
        let clear = NAButton("Clear", refs: refs)
        clear.frame = CGRect(x: 50, y:30, width: 100, height: 30)
        clear.setTitle("clear", for: .normal)
        clear.setTitleColor(UIColor.blue, for: .normal)
        self.view.addSubview(clear)

        //let sClearIt = clear.clicked.map { _ in "" }
        let sClearIt = SodiumSwift.Stream<String>()
        let text = NATextField(s: sClearIt, text: "Hello", refs: refs)
        text.text = "Hello2"
        text.frame = CGRect(x:10, y: 50, width:100, height: 20)
        
        self.view.addSubview(text)
        
        
        let close = UIButton()
        close.frame = CGRect(x: 50, y:130, width: 100, height: 30)
        close.setTitle("close", for: .normal)
        close.setTitleColor(UIColor.blue, for: .normal)
        close.addTarget(self, action: #selector(doclose), for: .touchUpInside)
        self.view.addSubview(close)
    }

    func doclose() {
        self.dismiss(animated: true, completion: nil)
    }
}
