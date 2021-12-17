//
//  SuccessModel.swift
//  FruitsDiary
//
//  Created by Gajula Ravi Kiran on 17/12/2021.
//

import Foundation

struct SuccessResponse:Codable {
    var code:Int?
    var message:String?

    enum CodingKeys:String,CodingKey {
        case code
        case message
    }
}
