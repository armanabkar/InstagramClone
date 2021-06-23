//
//  UIAlertControllerExtension.swift
//  InstagramClone
//
//  Created by Arman Abkar on 6/23/21.
//

import UIKit

extension UIAlertController {
    static func showAlert(title: String? = "Error", message: String, from controller: UIViewController) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default)
        
        alertController.addAction(okAction)
        
        controller.present(alertController, animated: true, completion: nil)
    }
}
