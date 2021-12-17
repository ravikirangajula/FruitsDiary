//
//  DropdownListViewController.swift
//  FruitsDiary
//
//  Created by Gajula Ravi Kiran on 16/12/2021.
//

import UIKit

class DropdownListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var availableFruits = UserDefaults.standard.availableFruits
    var tableViewItemSelected: ((_ list: AvailableFruit) -> ())?

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableViewCell()
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.reloadData()
        // Do any additional setup after loading the view.
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
                cell.nameLabel.text = availableFruits[indexPath.row].type ?? ""
                cell.fruitCount.text = "Fruits quantity 1"
                cell.vitamins.text = "Vitamins: \(availableFruits[indexPath.row].vitamins))"
                ImageDownLoadHelper.downloaded(from: BASE_URL + "\(availableFruits[indexPath.row].image ?? "image/apple.png")", completionHandler: { image in
                    cell.fruitImageView.image = image
                })
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

