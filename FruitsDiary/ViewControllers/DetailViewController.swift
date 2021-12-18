//
//  DetailViewController.swift
//  FruitsDiary
//
//  Created by Gajula Ravi Kiran on 14/12/2021.
//

import UIKit

class DetailViewController: BaseViewController {

    @IBOutlet weak var detailTableView: UITableView!
    var item = CurrentEntires()
    lazy var viewModel: DetailViewModel = { [weak self] in
        return DetailViewModel()
    }()
    
    static func DetailViewController() -> DetailViewController {
      let vc = instantiate(viewControllerIdentifier: "DetailViewController") as! DetailViewController
      return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Entry Details"
        viewModel = DetailViewModel(list: item)
        setUpTableViewCell()
        setUpTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.editEntry = self.editEntry
        detailTableView.reloadData()
    }
    
    private func setUpTableView() {
        self.detailTableView.dataSource = viewModel
        self.detailTableView.delegate = viewModel
        self.detailTableView.separatorStyle = .none
        self.detailTableView.rowHeight = UITableView.automaticDimension
    }
    
    private func setUpTableViewCell() {
        self.detailTableView.register(UINib(nibName: DetailTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: DetailTableViewCell.identifier)
    }

}

//MARK: CallBacks
extension DetailViewController {
    
    func editEntry(_ item : FruitEntryFields?) {
        let vc = FruitEntryViewController.instantiate()
        vc.fruitEntryObj = item
        vc.mode = .edit
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        self.present(navVC, animated: true, completion: nil)
    }
}
