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
        getAvailableFruisList()
        getCurrentEntries()
    }
    
}
//MARK: Private Methods
extension HomeViewModel {
    
  
    private func getAvailableFruisList() {
        APIWrapper.getRequest(with: AVAILABLE_FRUITS, decodingType: [AvailableFruit].self) { [weak self] res, Error in
            guard let self = self else { return }
            if let responseObj = res as? [AvailableFruit]{
                self.availableFruits = responseObj
                UserDefaults.standard.availableFruits = responseObj
            }
        }
    }
    
    private func getCurrentEntries() {
        APIWrapper.getRequest(with: COMMON_URL, decodingType: [CurrentEntires].self) { [weak self] entries, Error in
            if let currentEntries = entries as? [CurrentEntires] {
                print("Current Entries == \(currentEntries)")
                print("Current Entries Error == \(String(describing: Error))")
                let sortedList = currentEntries.filter({$0.fruit?.count ?? 0 > 0}).sorted(by: { ($0.date ?? "0") > ($1.date ?? "0")})
                self?.allEntries = sortedList
                self?.reloadTableView?()
            }
        }
    }
    
    private func deleteSingleEntry(entryID:Int) {
        let url = DELETE_SIGNLE_ENTRY + "\(entryID)"
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

//MARK: Public Methods
extension HomeViewModel {
    
    func refreshList() {
        getCurrentEntries()
    }
    
    func deleteEntry(url:String = COMMON_URL) {
        guard let url = URL(string: String(url)) else { return }
        APIWrapper.deleteRequest(url: url) { [weak self] isSuccess in
            self?.refreshList()
           // self?.reloadTableView?()
        }
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
