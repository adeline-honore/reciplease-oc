//
//  RecipesListTableViewCell.swift
//  Reciplease-oc
//
//  Created by HONORE Adeline on 25/06/2022.
//

import UIKit

class RecipesListTableViewCell: UITableViewCell {

    static let identifier = "recipesListTableViewCell"
    
    @IBOutlet weak var recipesListImageView: UIImageView!
    
    @IBOutlet weak var recipesListTitle: UILabel!
    
    @IBOutlet weak var recipesListTotalTime: UILabel!
    
    @IBOutlet weak var recipesListIngredientLines: UILabel!
    
    @IBOutlet weak var datasStackView: UIStackView!
    
    @IBOutlet weak var datasView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
