//
//  IngredientsView.swift
//  Reciplease-oc
//
//  Created by HONORE Adeline on 29/05/2022.
//

import UIKit

class IngredientsView: UIView {
    
    // MARK: - Outlet
    @IBOutlet weak var ingredientsTextField: UITextField!
    
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var clearAllButton: UIButton!
    
    @IBOutlet weak var inMyFridgeLabel: UILabel!
    
    @IBOutlet weak var myIngredientsLabel: UILabel!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
}

extension IngredientsView {
    func configureAccessibility() {
        
        inMyFridgeLabel.isAccessibilityElement = false
        myIngredientsLabel.isAccessibilityElement = false
        
        ingredientsTextField.accessibilityLabel = "ingredients text field"
        ingredientsTextField.accessibilityHint = " enter an ingredient"
        
        addButton.accessibilityHint = "Press Add Button to add an ingredient"
        
        clearAllButton.accessibilityHint = "Press Clear All Buton to remove all ingredients"
        
        if activityIndicator.isAnimating {
            activityIndicator.accessibilityHint = "loading recipes "
        }
    }
}
