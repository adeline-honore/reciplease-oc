//
//  Extension+UIView.swift
//  Reciplease-oc
//
//  Created by HONORE Adeline on 05/07/2022.
//

import UIKit

extension UIView {
    func manageDataViewBackground() {
        backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.2)
    }
    
    func manageFavoriteStarImageView(imageView: UIImageView, isFavorite: Bool) {
        imageView.tintColor = isFavorite ? .orange : .white
    }
    
    func manageFavoriteStarButton(button: UIButton, isFavorite: Bool) {
        button.tintColor = isFavorite ? .orange : .white
    }
    
    func manageTimeView(time: Double, timeLabel: UILabel, clockView: UIView, infoStack: UIStackView) {
        timeLabel.isHidden = time.isZero
        clockView.isHidden = time.isZero
        
        if !time.isZero {
            infoStack.manageDataViewBackground()
        }
    }
}
