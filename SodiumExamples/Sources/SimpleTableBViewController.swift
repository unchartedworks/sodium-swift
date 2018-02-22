//
//  SimpleTableBViewController.swift
//  SodiumExamples
//
//  Created by Liang on 20/02/2018.
//  Copyright © 2018 UnchartedWorks. All rights reserved.
//

import UIKit
import SodiumSwift
import SodiumCocoa

class SimpleTableBViewController: UIViewController {

    @IBOutlet weak var tableView: STableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
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
extension SimpleTableBViewController {
    func setup(_ items: [SectionModel<Any, Any>]) {
        setupDataSource(items, tableView)
        setupSelectStream(tableView)
    }
}

//MARK: Behaviors & Events
extension SimpleTableBViewController {
    /* Data Source CellSink (Behavior)*/
    func setupDataSource(_ items: [SectionModel<Any, Any>], _ tableView: STableView) {
        tableView.csItems.send(items)
    }

    /* Select StreamSink (Event) */
    func setupSelectStream(_ tableView: STableView) {
        _ = tableView.select.map(itemAtIndexPath).listen { self.showAlert($0) }
    }
}

extension SimpleTableBViewController {
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

//MARK: Data Source
extension SimpleTableBViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.textColor = UIColor.blue
        return cell
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableView.tableView(tableView, numberOfRowsInSection: section)
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return self.tableView.numberOfSections(in: tableView)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.tableView.tableView(tableView, titleForHeaderInSection: section)?.uppercased()
    }
}
