//
//  SegmentViewController.swift
//  SodiumExamples
//
//  Created by Liang on 22/02/2018.
//  Copyright © 2018 UnchartedWorks. All rights reserved.
//

import UIKit
import SodiumSwift
import SodiumCocoa

class SegmentViewController: UIViewController {
    
    @IBOutlet weak var segmentedControl: SSegmentedControl!
    @IBOutlet weak var textLabel: SLabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let initialTitle = segmentedControl.titleForSegment(at: segmentedControl.selectedSegmentIndex) ?? ""
        textLabel.cText = segmentedControl.select.map({self.segmentedControl.titleForSegment(at: $0) ?? ""}).hold(initialTitle)
    }
}
