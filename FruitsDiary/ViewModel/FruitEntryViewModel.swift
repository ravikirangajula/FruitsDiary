//
//  AddListViewModel.swift
//  FruitsDiary
//
//  Created by Gajula Ravi Kiran on 16/12/2021.
//

import Foundation

enum Mode {
    case entry
    case edit
}

struct AddEntryParms {
    var id:Int?
    var date:String?
    var fruitID:Int
    var count:String
}

class FruitEntryViewModel: NSObject {
    var items:AddEntryParms?
    var mode:Mode = .entry
    
    override init() {
        super.init()
    }
    
    public func submitEntry(items:AddEntryParms, completion: @escaping(Bool) -> ()) {
        switch mode {
        case .edit:
            guard let entryId = items.id else { return }
            addFruitsToEntry(enteryID: String(entryId), fruit: items.fruitID, amount: items.count) { isSuccess in
                completion(isSuccess)
            }
        default:
            guard let date = items.date else { return }
            createEntery(date: date) { entryID in
                if let id = entryID {
                    self.addFruitsToEntry(enteryID: String(id), fruit: items.fruitID, amount: items.count) {  isSuccess in
                        completion(isSuccess)
                    }
                }
            }
        }
    }
    
    private func createEntery(date:String, completion: @escaping(_ enteryId: Int?) -> ()) {
        let parms:[String:Any] = ["date": date]
        APIWrapper.postRequest(with: "https://fruitdiary.test.themobilelife.com/api/entries", parms: parms, decodingType: CurrentEntires.self) { res, error in
            if let res = res  as? CurrentEntires {
                print("createEntery Success == \(res)")
                completion(res.id)
            } else {
                print("createEntery Error == \(error)")
            }
        }
    }
    
    private func addFruitsToEntry(enteryID: String, fruit:Int, amount:String, completion: @escaping(_ Success: Bool) -> ()) {
        APIWrapper.postRequest(with: "https://fruitdiary.test.themobilelife.com/api/entry/\(enteryID)/fruit/\(fruit)?amount=\(amount)", decodingType: SuccessResponse.self) { [weak self] data, error in
            guard let _ = self else { return }
            if let data = data as? SuccessResponse {
                if data.code == 200 {
                    completion(true)
                }
                print("addFruitsToEntry Success == \(data)")
            }
        }
    }

}

extension FruitEntryViewModel {
    
    func formatDate(selectedDate:Date) -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: selectedDate)
    }
}
