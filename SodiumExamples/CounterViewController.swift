//
//  CounterViewController.swift
//  SodiumExamples
//
//  Created by Liang on 10/02/2018.
//  Copyright © 2018 Whirlygig Ventures. All rights reserved.
//

import UIKit
import SodiumCocoa
import SodiumSwift

class CounterViewController: UIViewController {

    @IBOutlet weak var counterLabel: NALabel!
    @IBOutlet weak var plusButton: NAButton!
    @IBOutlet weak var minusButton: NAButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    func setup() {
        let sPlus        = plusButton.clicked.mapTo(1)
        let sMinus       = minusButton.clicked.mapTo(-1)
        let count        = {(x: Int, y: Int) in x + y}
        counterLabel.txt = sPlus.orElse(sMinus).accum(0, f: count).map({String($0)})
    }
}
