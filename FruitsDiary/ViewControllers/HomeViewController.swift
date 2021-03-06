//
//  HomeViewController.swift
//  FruitsDiary
//
//  Created by Gajula Ravi Kiran on 12/12/2021.
//

import UIKit

class HomeViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    lazy var viewModel: HomeViewModel = { [weak self] in
        return HomeViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "My Diary"
        viewModel = HomeViewModel()
        setNavigationItems()
        setUpTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.refreshList()
        reloadTableView()
        viewModel.reloadTableView = { [weak self] in
            guard let self = self else { return }
            self.reloadTableView()
        }
        viewModel.tableViewItemSelected = { [weak self] item in
            guard let self = self else { return }
            self.tableViewItemSelected(item)
        }
    }
    
    @objc func addTapped() {
        let vc = FruitEntryViewController.instantiate()
        vc.currentEntriesList = viewModel.allEntries
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        self.present(navVC, animated: true, completion: nil)
    }
    
    @objc func clearAllTapped() {
        viewModel.deleteEntry()
    }
    
    deinit {
        print("HomeViewController memory released")
    }
}

//MARK: UI
extension HomeViewController {
    
    private func setNavigationItems() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addTapped))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Delete All", style: .plain, target: self, action: #selector(clearAllTapped))
    }
    
    private func setUpTableView() {
        self.registerCell()
        self.tableView.dataSource = viewModel
        self.tableView.delegate = viewModel
        self.tableView.separatorStyle = .none
        self.tableView.rowHeight = UITableView.automaticDimension
    }
    
    private func registerCell() {
        self.tableView.register(UINib(nibName: HomeViewCell.identifier, bundle: nil), forCellReuseIdentifier: HomeViewCell.identifier)
    }
}

//MARK: CallBacks
extension HomeViewController {
    
    private func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    private func tableViewItemSelected(_ list: CurrentEntires) {
        DispatchQueue.main.async {
            guard let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: "DetailViewController") as? DetailViewController else  { return }
            vc.item = list
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
