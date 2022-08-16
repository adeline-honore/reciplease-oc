//
//  RecipeTableViewCell.swift
//  Reciplease-oc
//
//  Created by HONORE Adeline on 08/07/2022.
//

import UIKit

class RecipeTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var imageCell: UIImageView!

    @IBOutlet weak var titleCell: UILabel!
    
    @IBOutlet weak var timeCell: UILabel!
    
    @IBOutlet weak var clockCell: UIImageView!
    
    @IBOutlet weak var ingredientsCell: UILabel!
    
    @IBOutlet weak var datasViewCell: UIView!
    
    @IBOutlet weak var favoriteStar: UIImageView!
    
    @IBOutlet weak var infoStackCell: UIStackView!
    
    
    static let identifier = "recipeCellIdentifier"
    
    
    // MARK: - Life
    override func awakeFromNib() {
        super.awakeFromNib()
        self.frame = bounds
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(titleValue: String, timeValue: String, ingredientsValue: String, imageValue: UIImage) {
        titleCell.text = titleValue
        timeCell.text = timeValue
        ingredientsCell.text = ingredientsValue
        imageCell.image = imageValue
    }
}
