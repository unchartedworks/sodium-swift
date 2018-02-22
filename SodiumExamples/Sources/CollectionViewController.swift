//
//  CollectionViewController.swift
//  SodiumExamples
//
//  Created by Liang on 21/02/2018.
//  Copyright © 2018 UnchartedWorks. All rights reserved.
//

import UIKit
import SodiumSwift
import SodiumCocoa

class CollectionViewController: UIViewController {

    @IBOutlet weak var collectionView: SCollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.dataSource = self
        self.collectionView.delegate   = self
        setup(initialData())
    }
    
    func initialData() -> [SectionModel<Any, Any>] {
        return [
            SectionModel<Any, Any>(section: "Classic Physics",
                                   items: ["Classical mechanics", "Classical electrodynamics", "Classical thermodynamics"]),
            SectionModel<Any, Any>(section: "Modern Physics",
                                   items: ["Quantum mechanics", "Einsteinian relativity"])
        ]
    }
}
//MARK: Logic
extension CollectionViewController {
    func setup(_ items: [SectionModel<Any, Any>]) {
        setupDataSource(items, collectionView)
    }
}

//MARK: Behaviors & Events
extension CollectionViewController {
    /* Data Source CellSink (Behavior)*/
    func setupDataSource(_ items: [SectionModel<Any, Any>], _ collectionView: SCollectionView) {
        collectionView.csItems.send(items)
    }
}

//MARK: Data Source
extension CollectionViewController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        func createHeaderView(_ kind: String, _ indexPath: IndexPath) -> UICollectionReusableView {
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerView", for: indexPath) as! SimpleHeaderView
            view.textLabel.text = self.collectionView.items[indexPath.section].section as? String
            view.backgroundColor = UIColor.lightGray
            return view
        }
        
        func createFooterView(_ kind: String, _ indexPath: IndexPath) -> UICollectionReusableView {
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "footerView", for: indexPath)
            return view
        }
        
        switch kind {
        case UICollectionElementKindSectionHeader:
            return createHeaderView(kind, indexPath)
        case UICollectionElementKindSectionFooter:
            return createFooterView(kind, indexPath)
        default:
            assert(false, "Unexpected element kind: \(kind)")
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SimpleCollectionViewCell
        cell.textLabel.text = (self.collectionView.items[indexPath.section].items[indexPath.row] as! String)
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.collectionView.items[section].items.count
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.collectionView.items.count
    }
}

extension CollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        func itemAtIndexPath(indexPath: IndexPath) -> String {
            return self.collectionView.items[indexPath.section].items[indexPath.row] as! String
        }
        
        func showAlert(_ item: String) {
            let alertController = UIAlertController(title: item,
                                                    message: "",
                                                    preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
        }
        showAlert(itemAtIndexPath(indexPath: indexPath))
    }
}

class SimpleHeaderView: UICollectionReusableView {
    @IBOutlet weak var textLabel: UILabel!
}

class SimpleFooterView: UICollectionReusableView {
}

class SimpleCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var textLabel: UILabel!
}
