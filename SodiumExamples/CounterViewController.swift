//
//  CounterViewController.swift
//
//  Created by Liang on 10/02/2018.

import UIKit
import SodiumCocoa
import SodiumSwift

class CounterViewController: UIViewController {
    @IBOutlet weak var counterLabel: NALabel!
    @IBOutlet weak var upButton: NAButton!
    @IBOutlet weak var downButton: NAButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        counterLabel.txt = count(upButton, downButton)
    }
}

func count(_ upButton: NAButton!, _ downButton: NAButton!) -> Cell<String> {
    let sUp          = upButton.clicked.mapTo(1)
    let sDown        = downButton.clicked.mapTo(-1)
    return sUp.orElse(sDown).accum(0, f: +).map({String($0)})
}
