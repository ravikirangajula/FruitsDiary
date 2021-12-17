//
//  FruitEnteryDataSource.swift
//  FruitsDiary
//
//  Created by Gajula Ravi Kiran on 12/12/2021.
//

import Foundation
import UIKit

class FruitEnteryDataSource: NSObject {
    
    var allEntries = [CurrentEntires]()
    
    override init() {
    }
    
    convenience init(list:[CurrentEntires]) {
        self.init()
        self.allEntries = list
        removeEmptyList()
    }
    
    private func numberOfRows(section:Int) -> Int {
        return allEntries[section].fruit?.count ?? 0
    }
    
    private func numberOfSections() -> Int {
        return allEntries.count
    }
}

extension FruitEnteryDataSource {
    
    private func removeEmptyList() {
        let list = allEntries.filter({$0.fruit?.count ?? 0 > 0})
        allEntries.removeAll()
        allEntries = list
    }
    
}

//extension FruitListViewModel: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return allEntries[section].fruit?.count ?? 0
//    }
//
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 44
//    }
//
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//
//        return allEntries[section].date ?? "-"
//    }
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return allEntries.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if let cell = tableView.dequeueReusableCell(withIdentifier: FruitsListableViewCell.identifier) as? FruitsListableViewCell {
//            cell.titleLabel.text = allEntries[indexPath.section].fruit?[indexPath.row].fruitType ?? ""
//            return cell
//        }
//        return UITableViewCell()
//    }
//
//
//}

//extension FruitEnteryDataSource: UITableViewDelegate {
//    
//}
