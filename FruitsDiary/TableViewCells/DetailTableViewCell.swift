//
//  DetailTableViewCell.swift
//  FruitsDiary
//
//  Created by Gajula Ravi Kiran on 14/12/2021.
//

import UIKit

class DetailTableViewCell: UITableViewCell {
    @IBOutlet weak var containerView: UIView! {
        didSet {
            containerView.setCornerRadius(radius: CORNER_RADIUS)
        }
    }
    
    static let identifier = "DetailTableViewCell"
    
    @IBOutlet weak var fruitImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var fruitCount: UILabel!
    @IBOutlet weak var vitamins: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
