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
        
        animateText(Constants.appName)
    }
    
    @IBAction func signInClicked(_ sender: Any) {
        if emailText.text != "" && passwordText.text != "" {
            Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!) { (authData, error) in
                if error != nil {
                    UIAlertController.showAlert(message: error?.localizedDescription ?? "Error", from: self)
                } else {
                    self.performSegue(withIdentifier: Constants.feedSegue, sender: nil)
                }
            }
        } else {
            UIAlertController.showAlert(message: "Please enter a valid username/password.", from: self)
        }
    }
    
    @IBAction func signUpClicked(_ sender: Any) {
        if emailText.text != "" && passwordText.text != "" {
            Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!) { (authData, error) in
                if error != nil {
                    UIAlertController.showAlert(message: error?.localizedDescription ?? "Error", from: self)
                } else {
                    self.performSegue(withIdentifier: Constants.feedSegue, sender: nil)
                }
            }
        } else {
            UIAlertController.showAlert(message: "Please enter a valid username/password.", from: self)
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
