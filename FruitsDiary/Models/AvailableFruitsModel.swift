//
//  AvailableFruitsModel.swift
//  FruitsDiary
//
//  Created by Gajula Ravi Kiran on 17/12/2021.
//

import Foundation

struct AvailableFruit:Codable {
    var id:Int?
    var type:String?
    var vitamins:Int?
    var image:String?

    enum CodingKeys:String,CodingKey {
        case id
        case type
        case vitamins
        case image
    }
}
