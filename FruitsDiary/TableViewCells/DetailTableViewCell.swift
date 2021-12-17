//
//  DetailTableViewCell.swift
//  FruitsDiary
//
//  Created by Gajula Ravi Kiran on 14/12/2021.
//

import UIKit

class DetailTableViewCell: UITableViewCell {
    static let identifier = "DetailTableViewCell"
    @IBOutlet weak var containerView: UIView! {
        didSet {
            containerView.setCornerRadius(radius: CORNER_RADIUS)
        }
    }
 
    @IBOutlet weak var fruitImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var fruitCount: UILabel!
    @IBOutlet weak var vitamins: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setUpCell(item:DetailCell) {
        if let name = item.fruitName {
            nameLabel.text = name
        }
        if let count = item.fruitVitamins {
            fruitCount.text = "Fruits Intake \(count)"
        }
        if let vitaminsCount = item.fruitsCount {
            vitamins.text =  "Vitamins \(vitaminsCount)"
        }
        if let image = item.fruitImage {
            ImageDownLoadHelper.downloaded(from: BASE_URL + image, completionHandler: { [weak self] image in
                self?.fruitImageView.image = image
            })
        }
    }
    
}
