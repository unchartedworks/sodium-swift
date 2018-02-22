//
//  GalleryViewController.swift
//  SodiumExamples
//
//  Created by Liang on 18/02/2018.
//  Copyright © 2018 UnchartedWorks. All rights reserved.
//

import UIKit
import SodiumSwift
import SodiumCocoa

class GalleryViewController: UIViewController {

    @IBOutlet weak var imageView: SImageView!
    @IBOutlet weak var nextButton: SButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.cImage = cellImage(nextButton)
    }
}

func cellImage(_ button: SButton) -> Cell<UIImage> {
    let images: [UIImage]  = {
        let xs             = Array<Int>(1...3)
        let loadImage      = {(i: Int) -> UIImage? in UIImage(named: String(i) + ".png")}
        return xs.map(loadImage).flatMap({$0})
    }()
    let imageWithIndex      = {(x: Int) -> UIImage in
        let divide               = {(x: Int) in x % images.count}
        let _imageWithIndex      = {(x: Int) in images[x]}
        return _imageWithIndex(divide(x))
    }
    return button.tap.mapTo(1).accum(0, f: +).stream().map(imageWithIndex).hold(images[0])
}
