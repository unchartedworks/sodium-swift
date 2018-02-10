//
//  FirstViewController.swift
//  Example 2.1
//
//  Created by Andrew Bradnan on 5/20/16.
//  Copyright © 2016 Whirlygig Ventures. All rights reserved.
//

import UIKit
import SodiumSwift
import SodiumCocoa

class FirstViewController: UIViewController {
    
    let refs = MemReferences()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //let vc = Example21()
        let vc = Example24()
        vc.refs = self.refs
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.present(vc, animated: true, completion: nil)
        }
        merge2()
        cl()
    }
    
    func merge2() {
        let ones        = CellSink<Int>(1)
        let hundreds    = ones.map({ x in x * 100})
        let sum         = ones.lift(hundreds, f: {(o, h) in o + h})
        let listener    = sum.listen({s in print(s)})
        ones.send(2)
        ones.send(3)
        listener.unlisten()

        let adds: (Int, Int) -> Int = { (x, y) in return x + y }
        let s = SodiumSwift.StreamSink<Int>(fold: adds)
        let listener2 = s.listen(handler: {s in print(s)})
        s.send(1)
        Transaction.run { (t) in
            s.send(5)
            s.send(7)
            s.send(9)
        }
        s.send(100)
        listener2.unlisten()
    }

    func cl() {
        let cc = CellSink<Bool>(false)
        let ss = SodiumSwift.Stream<Int>()
        let sg = ss.gate(cc)
        let listener = sg.listen(handler: {s in print(s)})
        listener.unlisten()
    }

    func sequence<A>(_ xs: [Cell<A>]) -> Cell<Array<A>> {
        var ys = Cell<Array<A>>(value: Array<A>())
        for x in xs {
            ys = ys.map({zs in
                zs + [x.sample()]
            })
        }
        return ys
    }
}

