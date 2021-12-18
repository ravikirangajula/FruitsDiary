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
    var currentEntriesList = [CurrentEntires]()
   
    override init() {
        super.init()
    }
    
    convenience init(currentEntries:[CurrentEntires]) {
        self.init()
        currentEntriesList = currentEntries
    }
    
     func submitEntry(items:AddEntryParms, completion: @escaping(Bool) -> ()) {

        switch mode {
        case .edit:
            guard let entryId = items.id else { return }
            addFruitsToEntry(enteryID: String(entryId), fruit: items.fruitID, amount: items.count) { isSuccess in
                completion(isSuccess)
            }
        default:
            guard let date = items.date else { return }
            if let entryID = getEntryId(stringDate: date) {
                addFruitsToEntry(enteryID: String(entryID), fruit: items.fruitID, amount: items.count) { isSuccess in
                    completion(isSuccess)
                }
                return
            }
            createEntery(date: date) { entryID in
                if let id = entryID {
                    self.addFruitsToEntry(enteryID: String(id), fruit: items.fruitID, amount: items.count) {  isSuccess in
                        print("createEntery Success with ")
                        completion(isSuccess)
                    }
                } else {
                    print("createEntery fail with ")
                    completion(false)
                }
            }
        }
    }
    
    
    private func getEntryId(stringDate:String) -> Int? {
        return currentEntriesList.first(where: {$0.date == stringDate})?.id
    }
    
    private func createEntery(date:String, completion: @escaping(_ enteryId: Int?) -> ()) {
        let parms:[String:Any] = ["date": date]
        APIWrapper.postRequest(with: COMMON_URL, parms: parms, decodingType: CurrentEntires.self) { res, error in
            if let res = res  as? CurrentEntires {
                print("createEntery Success == \(res)")
                completion(res.id)
            } else {
                print("createEntery Error == \(String(describing: error))")
                completion(nil)
            }
        }
    }
    
    private func addFruitsToEntry(enteryID: String, fruit:Int, amount:String, completion: @escaping(_ Success: Bool) -> ()) {
        APIWrapper.postRequest(with: ADD_SIGNLE_ENTRY + "\(enteryID)/fruit/\(fruit)?amount=\(amount)", decodingType: SuccessResponse.self) { [weak self] data, error in
            guard let _ = self else { return }
            if let data = data as? SuccessResponse {
                if data.code == 200 {
                    print("AddFruitsToEntry Success == \(data)")
                    completion(true)
                }
            } else {
                completion(false)
            }
        }
    }

}

extension FruitEntryViewModel {
    
    func formatDate(selectedDate:Date) -> String? {
        return selectedDate.getStringFromDate()
    }
}
