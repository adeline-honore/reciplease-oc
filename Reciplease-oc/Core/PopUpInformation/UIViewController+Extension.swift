//
//  UIViewController+Extension.swift
//  Reciplease-oc
//
//  Created by HONORE Adeline on 14/06/2022.
//

import Foundation
import UIKit


extension UIViewController {
    private func displayAlert(title: String? = nil, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
    func errorMessage(element: ErrorType) {
        displayAlert(message: element.message)
    }
    
    func informationMessage(element: InfoType) {
        displayAlert(message: element.message)
    }
    
    func manageFavoriteStar(imageView: UIImageView, isFavorite: Bool) {
        imageView.tintColor = isFavorite ? .orange : .white
    }
    
    func manageTimeView(time: Double, labelView: UILabel, clockView: UIView, infoStack: UIStackView) {
        
        if time.isZero {
            labelView.isHidden = true
            clockView.isHidden = true
        } else {
            labelView.isHidden = false
            clockView.isHidden = false
            infoStack.manageDataViewBackground()
        }
    }
    
    func manageTimeDouble(time: Double) -> String {
        return (time.isZero) ? "0" : String(Int(time)) + " mn  "
    }
}
