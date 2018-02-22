//
//  SilderViewController.swift
//  SodiumExamples
//
//  Created by Liang on 19/02/2018.
//  Copyright © 2018 UnchartedWorks. All rights reserved.
//

import UIKit
import SodiumSwift
import SodiumCocoa

class SilderViewController: UIViewController {

    @IBOutlet weak var slider: SSlider!
    @IBOutlet weak var resultLabel: SLabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        resultLabel.cText = slider.csValue.map({String(Int($0 * 100)) + "%"})
    }
}
