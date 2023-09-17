//
//  RestaurantTableViewCell.swift
//  SubmissionPemulaIOS
//
//  Created by Ifvo Deky Wirawan on 11/06/23.
//

import UIKit

class RestaurantTableViewCell: UITableViewCell {
    
    @IBOutlet weak var indicatorLoading: UIActivityIndicatorView!
    @IBOutlet weak var restaurantLabel: UILabel!
    @IBOutlet weak var restaurantImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        restaurantImageView.layer.borderWidth = 1
        restaurantImageView.layer.masksToBounds = false
        restaurantImageView.layer.cornerRadius = 8
        restaurantImageView.clipsToBounds = true
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
