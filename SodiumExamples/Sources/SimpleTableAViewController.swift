//
//  SimpleTableAViewController.swift
//  SodiumExamples
//
//  Created by Liang on 20/02/2018.
//  Copyright © 2018 UnchartedWorks. All rights reserved.
//

import UIKit
import SodiumSwift
import SodiumCocoa

class SimpleTableAViewController: UIViewController {

    @IBOutlet weak var tableView: STableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setup(items())
    }

    func items() -> [SectionModel<Any, Any>] {
        return [
            SectionModel<Any, Any>(section: "Classic Physics",
                                   items: ["Classical mechanics", "Classical electrodynamics", "Classical thermodynamics"]),
            SectionModel<Any, Any>(section: "Modern Physics",
                                   items: ["Quantum mechanics", "Einsteinian relativity"])
        ]
    }
}

//MARK: Logic
extension SimpleTableAViewController {
    func setup(_ items: [SectionModel<Any, Any>]) {
        setupDataSource(items, tableView)
        setupSelectStream(tableView)
    }
}

//MARK: Behaviors & Events
extension SimpleTableAViewController {
    /* Data Source CellSink (Behavior)*/
    func setupDataSource(_ items: [SectionModel<Any, Any>], _ tableView: STableView) {
        tableView.csItems.send(items)
    }

    /* Select StreamSink (Event) */
    func setupSelectStream(_ tableView: STableView) {
        _ = tableView.select.map(itemAtIndexPath).listen { self.showAlert($0) }
    }
}

extension SimpleTableAViewController {
    func itemAtIndexPath(indexPath: IndexPath) -> String {
        return tableView.csItems.sample()[indexPath.section].items[indexPath.row] as! String
    }

    func showAlert(_ item: String) {
        let alertController = UIAlertController(title: item, message: "", preferredStyle: .alert)

        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)

        present(alertController, animated: true, completion: nil)
    }
}
