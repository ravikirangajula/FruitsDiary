//
//  DetailViewModel.swift
//  FruitsDiary
//
//  Created by Gajula Ravi Kiran on 14/12/2021.
//

import Foundation
import UIKit

class DetailViewModel: NSObject {
    
    var editEntry: ((_ item : FruitEntryFields?) -> ())?
    var item = CurrentEntires()
    lazy var availableFruits = UserDefaults.standard.availableFruits
    
    override init() {
        super.init()
    }
    
    convenience init(list:CurrentEntires) {
        self.init()
        item = list
    }
    
    private func getCaloriesForFruit(fruitID:Int) -> Int? {
        let calore = availableFruits.filter({$0.id == fruitID}).map({$0.vitamins})
        return calore.first ?? 0
    }
    
    private func getTotalCalories(for row:Int) -> Int {
        var totla = 0
        if let lsi = item.fruit?[row].fruitId {
            let cal = getCaloriesForFruit(fruitID: lsi)
            totla += (cal ?? 0) * (item.fruit?[row].amount ?? 0)
            return totla
        }
        return totla
    }
    
    private func editSelectedItem(row:Int) {
        guard let obj = item.fruit?[row] else {return }
        let refObject = FruitEntryFields(entryDate: item.date, entryId: item.id, fruitId: obj.fruitId, fruitType: obj.fruitType, fruitQuantity: obj.amount)
        editEntry?(refObject)
    }
    
}

extension DetailViewModel: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return item.fruit?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: DetailTableViewCell.identifier) as? DetailTableViewCell {
            cell.nameLabel.text = item.fruit?[indexPath.row].fruitType ?? "-"
            cell.fruitCount.text = "Fruits Intake \(item.fruit?[indexPath.row].amount ?? 0)"
            cell.vitamins.text = "Vitamins\(getTotalCalories(for: indexPath.row))"
            ImageDownLoadHelper.downloaded(from: BASE_URL + "\(availableFruits[indexPath.row].image ?? "image/apple.png")", completionHandler: { image in
                cell.fruitImageView.image = image
            })
            return cell
        }
        return UITableViewCell()
    }
}

extension DetailViewModel: UITableViewDelegate {
   
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editButton = UIContextualAction(style: .normal, title: "Edit") {  (contextualAction, view, boolValue) in
            self.editSelectedItem(row: indexPath.row)
        }
        let swipeActions = UISwipeActionsConfiguration(actions: [editButton])
        return swipeActions
    }
    
}


struct detailElements {
    var title:String?
    var quantity:String?
    var Vitamins:String?
}
