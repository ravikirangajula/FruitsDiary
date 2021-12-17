//
//  FruitsListableViewCell.swift
//  FruitsDiary
//
//  Created by Gajula Ravi Kiran on 12/12/2021.
//

import UIKit

class HomeViewCell: UITableViewCell {
    @IBOutlet weak var containerView: UIView!{
        didSet {
            containerView.setCornerRadius(radius: CORNER_RADIUS)
        }
    }
    
    @IBOutlet weak var quantity: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    
    static let identifier = "HomeViewCell"
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
