//
//  RecipesListTableViewCell.swift
//  Reciplease-oc
//
//  Created by HONORE Adeline on 25/06/2022.
//

import UIKit

class CustomRecipesCell: UIView {

    //static let identifier = "recipesListTableViewCell"
    
    //@IBOutlet weak var recipesListImageView: UIImageView!
    
    @IBOutlet weak var recipesListTitle: UILabel!
    
    //@IBOutlet weak var recipesListTotalTime: UILabel!
    
    //@IBOutlet weak var recipesListIngredientLines: UILabel!
        
    @IBOutlet weak var datasView: UIView!
    
    @IBOutlet weak var globalView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func draw(_ rect: CGRect) {

            // Drawing code

        }

        override init(frame: CGRect) {

            // Call super init

            super.init(frame: frame)

            // 3. Setup view from .xib file

            configureXIB()

        }

        required init?(coder aDecoder: NSCoder) {

            // 1. setup any properties here

            // 2. call super.init(coder:)

            super.init(coder: aDecoder)

            // 3. Setup view from .xib file

            configureXIB()

        }

    func configureXIB() {

           globalView = configureNib()

            // use bounds not frame or it’ll be offset

           globalView.frame = bounds

            // Make the flexible view

        globalView.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]

            // Adding custom subview on top of our view (over any custom drawing > see note below)

            addSubview(globalView)

        }

        func configureNib() -> UIView {

            let bundle = Bundle(for: type(of: self))

            let nib = UINib(nibName: "CustomRecipesCell", bundle: bundle)

            let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView

            return view

        }

}


class RecipesListTableViewCell: UITableViewCell {

    
    
    //@IBOutlet weak var customRecipesCell: CustomRecipesCell!
    
    static let identifier = "recipesListTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
