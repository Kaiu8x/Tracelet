//
//  LoginViewController.swift
//  TraceletApp
//
//  Created by Kai Kawasaki Ueda on 3/7/19.
//  Copyright © 2019 Kai Kawasaki Ueda. All rights reserved.
//

import Foundation
import Firebase
import UIKit

class LoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBOutlet weak var userNameTextField: UITextField!
    
    @IBOutlet weak var userPasswordTextField: UITextField!
    
    @IBAction func loginButton(_ sender: Any) {
        Auth.auth().signIn(withEmail: userNameTextField.text!, password: userPasswordTextField.text!) {
            (user, error) in
            if (error == nil) {
                UserDefaults.standard.set(true, forKey: "status")
                Switcher.updateRootViewController()
                self.performSegue(withIdentifier: "sucessLoginSegue", sender: self)
            } else {
                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    
    @IBAction func cancelLoginButton(_ sender: Any) {
        print("cancelLogin pushed")
        self.performSegue(withIdentifier: "cancelLoginSegue", sender: nil)
    }
    
}

