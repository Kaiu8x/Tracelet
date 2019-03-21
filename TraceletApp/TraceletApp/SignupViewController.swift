//
//  SignupViewController.swift
//  TraceletApp
//
//  Created by Kai Kawasaki Ueda on 3/7/19.
//  Copyright © 2019 Kai Kawasaki Ueda. All rights reserved.
//

import Foundation
import Firebase
import UIKit

class SignupViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
  
    
    @IBOutlet weak var userEmailTextField: UITextField!
    
    @IBOutlet weak var userPasswordTextField: UITextField!
    
    @IBOutlet weak var userPasswordConfirmTextField: UITextField!
    
    
    @IBAction func signupButton(_ sender: Any) {
        if (userPasswordTextField.text != userPasswordConfirmTextField.text) {
            let alertController = UIAlertController(title: "Password not same", message: "Please re-type same password", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        } else {
            Auth.auth().createUser(withEmail: userEmailTextField.text!, password: userPasswordTextField.text!) {
                (user, error) in
                
                if error == nil {
                    UserDefaults.standard.set(true, forKey: "status")
                    Switcher.updateRootViewController()
                    self.performSegue(withIdentifier: "sucessSignupSegue", sender: self)
                } else {
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
            
            
            
        }
        
        
    }
    

    @IBAction func cancelSignupButton(_ sender: Any) {
        print("cancelSignup pushed")
        self.performSegue(withIdentifier: "cancelSignupSegue", sender: nil)
    }
    
    
    
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
