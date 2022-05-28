//
//  IngredientTableViewCell.swift
//  Reciplease-oc
//
//  Created by HONORE Adeline on 29/05/2022.
//

import UIKit

class IngredientTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let identifier = "ingredientTableViewCell"

    // MARK: - Outlet
    @IBOutlet weak var ingredient: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
