//
//  EntryFruitsList.swift
//  FruitsDiary
//
//  Created by Gajula Ravi Kiran on 17/12/2021.
//

import Foundation

struct CurrentEntires:Codable {
    var id:Int?
    var date:String?
    var fruit:[FruitDetails]?

    enum CodingKeys:String,CodingKey {
        case id
        case date
        case fruit
    }
}
