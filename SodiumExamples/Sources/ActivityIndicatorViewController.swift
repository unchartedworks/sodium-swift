//
//  ActivityIndicatorViewController.swift
//  SodiumExamples
//
//  Created by Liang on 23/02/2018.
//  Copyright © 2018 UnchartedWorks. All rights reserved.
//

import UIKit
import SodiumSwift
import SodiumCocoa

class ActivityIndicatorViewController: UIViewController {
    @IBOutlet weak var activityIndictorView: SActivityIndicatorView!
    @IBOutlet weak var runButton: SButton!
    @IBOutlet weak var stopButton: SButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let sStart = runButton.tap.mapTo(true)
        let sStop  = stopButton.tap.mapTo(false)
        activityIndictorView.cAnimated = sStart.orElse(sStop).hold(false)
        activityIndictorView.hiddenState = activityIndictorView.cAnimated.map({!$0})
    }
    
}
