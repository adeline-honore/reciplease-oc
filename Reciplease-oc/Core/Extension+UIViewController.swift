//
//  Extension+UIViewController.swift
//  Reciplease-oc
//
//  Created by HONORE Adeline on 11/07/2022.
//

import UIKit

extension UIViewController {

    func isFavoriteRecipe(recipeLabel: String) -> Bool {
        let repository = RecipesCoreDataManager()
        return repository.isExistsInCoreData(title: recipeLabel)
    }
    
    func manageFavoriteStar(imageView: UIImageView,isFavaorite: Bool) {
        if isFavaorite {
            imageView.tintColor = .orange
        } else {
            imageView.tintColor = .gray
        }
    }
}
