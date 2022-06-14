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
}
