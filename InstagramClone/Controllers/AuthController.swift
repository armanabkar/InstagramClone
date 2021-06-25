//
//  ViewController.swift
//  InstagramClone
//
//  Created by Arman Abkar on 5/8/21.
//

import UIKit
import Firebase

class AuthController: UIViewController {
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        animateText(K.appName)
    }
    
    @IBAction func signInClicked(_ sender: Any) {
        if emailText.text != "" && passwordText.text != "" {
            Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!) { (authData, error) in
                if error != nil {
                    UIAlertController.showAlert(message: error?.localizedDescription ?? K.error.title, from: self)
                } else {
                    self.performSegue(withIdentifier: K.feedSegue, sender: nil)
                }
            }
        } else {
            UIAlertController.showAlert(message: K.error.invalidFieldMessage, from: self)
        }
    }
    
    @IBAction func signUpClicked(_ sender: Any) {
        if emailText.text != "" && passwordText.text != "" {
            Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!) { (authData, error) in
                if error != nil {
                    UIAlertController.showAlert(message: error?.localizedDescription ?? K.error.title, from: self)
                } else {
                    self.performSegue(withIdentifier: K.feedSegue, sender: nil)
                }
            }
        } else {
            UIAlertController.showAlert(message: K.error.invalidFieldMessage, from: self)
        }
    }
    
    private func animateText(_ text: String) {
        titleLabel.text = ""
        var charIndex = 0.0
        let titleText = text
        for letter in titleText {
            Timer.scheduledTimer(withTimeInterval: 0.1 * charIndex, repeats: false) { (timer) in
                self.titleLabel.text?.append(letter)
            }
            charIndex += 1
        }
    }
    
}
