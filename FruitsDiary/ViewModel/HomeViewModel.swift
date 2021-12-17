//
//  FruitListViewModel.swift
//  FruitsDiary
//
//  Created by Gajula Ravi Kiran on 12/12/2021.
//

import Foundation
import UIKit


class HomeViewModel: NSObject {
    var reloadTableView: (() -> ())?
    var tableViewItemSelected: ((_ list: CurrentEntires) -> ())?
    
    var allEntries = [CurrentEntires]()
    var availableFruits = [AvailableFruit]()
    
    override init() {
        super.init()
        callAPi()
        callCurrentList()
    }
    
    private func callAPi() {
        APIWrapper.getRequest(with: "https://fruitdiary.test.themobilelife.com/api/fruit", decodingType: [AvailableFruit].self) { [weak self] res, Error in
            guard let self = self else { return }
            if let responseObj = res as? [AvailableFruit]{
                self.availableFruits = responseObj
                UserDefaults.standard.availableFruits = responseObj
            }
        }
    }
    
    public func refreshList() {
        callCurrentList()
    }
    
    private func callCurrentList() {
        APIWrapper.getRequest(with: "https://fruitdiary.test.themobilelife.com/api/entries", decodingType: [CurrentEntires].self) { [weak self] res, Error in
            if let res1 = res as? [CurrentEntires] {
                print("res == \(res1)")
                print("Error == \(Error)")
                let list = res1.filter({$0.fruit?.count ?? 0 > 0})
                self?.allEntries = list
                self?.reloadTableView?()
            }
        }
    }
    
    
    public func deleteEntry(url:String = "https://fruitdiary.test.themobilelife.com/api/entries") {
        guard let url = URL(string: String(url)) else { return }
        APIWrapper.deleteRequest(url: url) { [weak self] isSuccess in
            self?.refreshList()
            self?.reloadTableView?()
        }
    }
    
    private func deleteSingleEntry(entryID:Int) {
        let url = "https://fruitdiary.test.themobilelife.com/api/entry/\(entryID)"
        self.deleteEntry(url: url)
    }
    
    private func getCaloriesForFruit(fruitID:Int) -> Int? {
        let calore = availableFruits.filter({$0.id == fruitID}).map({$0.vitamins})
        return calore.first ?? 0
    }
    
    private func getTotalFruits(for row:Int) -> Int {
        var totla = 0
        if let lsi = allEntries[row].fruit {
            for iten in lsi {
                totla += iten.amount ?? 0
            }
            return totla
        }
        return totla
    }
    
    private func getTotalCalories(for row:Int) -> Int {
        var totla = 0
        if let lsi = allEntries[row].fruit {
            for iten in lsi {
                let cal = getCaloriesForFruit(fruitID: iten.fruitId ?? 0)
                totla += (cal ?? 0) * (iten.amount ?? 0)
            }
            return totla
        }
        return totla
    }
}

extension HomeViewModel: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allEntries.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: HomeViewCell.identifier) as? HomeViewCell {
            cell.titleLabel.text = "Fruits intake: \(getTotalFruits(for: indexPath.row))"
            cell.caloriesLabel.text  = "Vitamins: \(getTotalCalories(for: indexPath.row))"
            cell.quantity.text  = allEntries[indexPath.row].date
            return cell
        }
        return UITableViewCell()
    }
}


extension HomeViewModel: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if  allEntries.indices.contains(indexPath.row) {
            tableViewItemSelected?(allEntries[indexPath.row])
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") {  (contextualAction, view, boolValue) in
            if let entryId = self.allEntries[indexPath.row].id {
                self.deleteSingleEntry(entryID: entryId)
            }
        }
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeActions
    }
    
}
