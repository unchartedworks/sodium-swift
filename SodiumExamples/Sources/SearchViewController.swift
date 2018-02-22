//
//  SearchViewController.swift
//  SodiumExamples
//
//  Created by Liang on 18/02/2018.
//  Copyright © 2018 UnchartedWorks. All rights reserved.
//

import UIKit
import SodiumSwift
import SodiumCocoa

class SearchViewController: UIViewController {

    @IBOutlet weak var searchBar: SSearchBar!
    @IBOutlet weak var textLabel: SLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.becomeFirstResponder()
        searchBar.csText.send("hello")
        textLabel.cText = cellText(searchBar)
        _ = searchBar.tap.map({ _ in print(self.searchBar.text ?? "")})
    }
    
    func cellText(_ searchBar: SSearchBar) -> Cell<String> {
        return searchBar.csText.map({$0.uppercased()})
    }
}
