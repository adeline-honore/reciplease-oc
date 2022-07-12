//
//  RecipeTableViewCell.swift
//  Reciplease-oc
//
//  Created by HONORE Adeline on 08/07/2022.
//

import UIKit

class RecipeTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var imageRecipeCell: UIImageView!

    @IBOutlet weak var titleRecipeCell: UILabel!
    
    @IBOutlet weak var timeRecipeCell: UILabel!
    
    @IBOutlet weak var ingredientsRecipeCell: UILabel!
    
    @IBOutlet weak var datasViewRecipeCell: UIView!
    
    @IBOutlet weak var favoriteStar: UIImageView!
    
    static let identifier = "recipeCellIdentifier"
    
    
    // MARK: - Life
    override func awakeFromNib() {
        super.awakeFromNib()
        self.frame = bounds
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    class func createCell() -> RecipeTableViewCell? {
        let nib = UINib(nibName: "RecipeTableViewCell", bundle: nil)
        let cell = nib.instantiate(withOwner: self, options: nil).last as? RecipeTableViewCell
        return cell
    }
}
