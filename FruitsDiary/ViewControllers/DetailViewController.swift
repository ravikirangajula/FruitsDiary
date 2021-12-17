//
//  DetailViewController.swift
//  FruitsDiary
//
//  Created by Gajula Ravi Kiran on 14/12/2021.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailTableView: UITableView!
    public var item = CurrentEntires()
    lazy var viewModel: DetailViewModel = { [weak self] in
        return DetailViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = DetailViewModel(list: item)
        setUpTableViewCell()
        setUpTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.editEntry = self.editEntry
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
        guard let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: "AddListViewController") as? FruitEntryViewController else  { return }
        vc.fruitEntryObj = item
        vc.mode = .edit
        let navVC = UINavigationController(rootViewController: vc)
        self.present(navVC, animated: true, completion: nil)
    }
}
