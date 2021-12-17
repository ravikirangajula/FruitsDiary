//
//  FruitDetailsModel.swift
//  FruitsDiary
//
//  Created by Gajula Ravi Kiran on 17/12/2021.
//

import Foundation

struct FruitDetails:Codable {
    var fruitId:Int?
    var fruitType:String?
    var amount:Int?

    enum CodingKeys:String,CodingKey {
        case fruitId
        case fruitType
        case amount
    }
}
