//
//  SettingsViewController.swift
//  InstagramClone
//
//  Created by Arman Abkar on 5/8/21.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var userLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let currentUser = Auth.auth().currentUser
        userLabel.text = currentUser?.email
    }
    
    @IBAction func logoutClicked(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: Constants.authSegue, sender: nil)
        } catch let signOutError as NSError {
            UIAlertController.showAlert(message: signOutError.localizedDescription, from: self)
        }
    }
    
}
