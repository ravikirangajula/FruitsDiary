//
//  AddListViewController.swift
//  FruitsDiary
//
//  Created by Gajula Ravi Kiran on 15/12/2021.
//

import UIKit

struct FruitEntryFields {
    var entryDate:String?
    var entryId:Int?
    var fruitId:Int?
    var fruitType:String?
    var fruitQuantity:Int?
}

class FruitEntryViewController: UIViewController {
    
    @IBOutlet weak var firstStack: UIStackView!
    @IBOutlet weak var fruitTypeField: UITextField!
    @IBOutlet weak var fruitCOunt: UITextField!
    
    var mode:Mode = .entry
    var datePicker = UIDatePicker()
    var fruitID:Int = 0
    var fruitEntryObj:FruitEntryFields?
    lazy var viewModel: FruitEntryViewModel = { [weak self] in
        return FruitEntryViewModel()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.setLeftBarButton(UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel)), animated: true)
        navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save)), animated: true)
        navigationItem.rightBarButtonItem?.isEnabled = false
        addGesture()
        addDatePicker()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureFields()
    }
    
    @objc func cancel() {
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
            self.presentingViewController?.viewWillAppear(true)
        }
    }
    
    @objc func save() {
        if let fruitType = self.fruitTypeField.text, !fruitType.isEmpty, let count = self.fruitCOunt.text, !count.isEmpty, let date = viewModel.formatDate(selectedDate: datePicker.date), !date.isEmpty {
            navigationItem.rightBarButtonItem?.isEnabled = true
            var item:AddEntryParms
            if mode == .edit {
                item = AddEntryParms(id: fruitEntryObj?.entryId, date: nil, fruitID: fruitID, count: count)
            } else {
                item = AddEntryParms(id:nil, date: date, fruitID: fruitID, count: count)
            }
            viewModel.items = item
            viewModel.mode = mode
            viewModel.submitEntry(items: item) { [weak self] isSucces in
                self?.cancel()
            }
        }
    }
    
    @objc func handleDateSelection() {
    }
    
    @objc func dismissKeyBoard() {
        self.view.endEditing(true)
    }
    

}

//MARK: Private methods
extension FruitEntryViewController {
    
    private func addGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyBoard))
        self.view.addGestureRecognizer(tap)
    }
    
    private func addDatePicker() {
        datePicker.date = Date()
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(handleDateSelection), for: .valueChanged)
        self.firstStack.insertArrangedSubview(datePicker, at: 1)
        self.firstStack.layoutSubviews()
    }
    
    private func validation() {
        if let fruitType = self.fruitTypeField.text, !fruitType.isEmpty, let count = self.fruitCOunt.text, !count.isEmpty {
            navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
    
    private func configureFields() {
        guard let currentEntryObj = fruitEntryObj else { return }
        if let type = currentEntryObj.fruitType, !type.isEmpty {
            self.fruitTypeField.text = type
        }
        if let amount = currentEntryObj.fruitQuantity{
            self.fruitCOunt.text = "\(amount)"
        }
        if let fruitID = currentEntryObj.fruitId{
            self.fruitID = fruitID
        }
    }
}

extension FruitEntryViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == fruitTypeField {
            guard let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: "DropdownListViewController") as? DropdownListViewController else  { return false }
            vc.tableViewItemSelected = self.tableViewItemSelected
            self.navigationController?.pushViewController(vc, animated: true)
            return false
        }
        return true
    }
    

    func textFieldDidEndEditing(_ textField: UITextField) {
        self.validation()
    }
}

//MARK: Callbacks
extension FruitEntryViewController {
    private func tableViewItemSelected(_ list: AvailableFruit) {
        if let obj = self.fruitEntryObj {
            self.fruitEntryObj?.fruitType = list.type
            self.fruitEntryObj?.fruitId = list.id
        } else {
            let obj2 = FruitEntryFields(entryDate: nil, entryId: nil, fruitId: list.id, fruitType: list.type, fruitQuantity: 0)
            self.fruitEntryObj = obj2
        }
        self.configureFields()
        self.validation()
    }
}
