//
//  SwitchViewController.swift
//  SodiumExamples
//
//  Created by Liang on 19/02/2018.
//  Copyright © 2018 UnchartedWorks. All rights reserved.
//

import UIKit
import SodiumSwift
import SodiumCocoa

class SwitchViewController: UIViewController {

    @IBOutlet weak var lightSwitch: SSwitch!
    @IBOutlet weak var resultLabel: SLabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        resultLabel.cText = lightSwitch.csValue.map({$0 ? "On" : "Off"})
    }
}
