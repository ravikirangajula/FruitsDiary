//
//  DropdownListViewController.swift
//  FruitsDiary
//
//  Created by Gajula Ravi Kiran on 16/12/2021.
//

import UIKit

class DropdownListViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var availableFruits = UserDefaults.standard.availableFruits
    var tableViewItemSelected: ((_ list: AvailableFruit) -> ())?
    
    static func instantiate() -> DropdownListViewController {
        let vc = instantiate(viewControllerIdentifier: "DropdownListViewController") as! DropdownListViewController
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableViewCell()
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.reloadData()
    }
    
    private func setUpTableViewCell() {
        self.tableView.register(UINib(nibName: DetailTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: DetailTableViewCell.identifier)
    }
    
}

extension DropdownListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return availableFruits.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: DetailTableViewCell.identifier) as? DetailTableViewCell {
            if availableFruits.indices.contains(indexPath.row) {
                let detailObject = DetailCell(fruitName: availableFruits[indexPath.row].type, fruitsCount: 1, fruitVitamins: availableFruits[indexPath.row].vitamins, fruitImage: availableFruits[indexPath.row].image)
                cell.setUpCell(item: detailObject)
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if  availableFruits.indices.contains(indexPath.row) {
            self.tableViewItemSelected?(self.availableFruits[indexPath.row])
            self.navigationController?.popViewController(animated: false)
        }
    }
    
}

