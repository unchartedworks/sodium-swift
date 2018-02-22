//
//  CounterViewController.swift
//
//  Created by Liang on 10/02/2018.

import UIKit
import SodiumCocoa
import SodiumSwift

class CounterAViewController: UIViewController {
    @IBOutlet weak var counterLabel: SLabel!
    @IBOutlet weak var upButton: SButton!
    @IBOutlet weak var downButton: SButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup(self)
    }
}

func setup(_ vc: CounterAViewController) {
    func count(_ upButton: SButton!, _ downButton: SButton!) -> Cell<String> {
        let sUp          = upButton.tap.mapTo(1)
        let sDown        = downButton.tap.mapTo(-1)
        return sUp.orElse(sDown).accum(0, f: +).map({String($0)})
    }

    vc.counterLabel.cText  = count(vc.upButton, vc.downButton)
}



