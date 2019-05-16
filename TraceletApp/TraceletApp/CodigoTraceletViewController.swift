//
//  CodigoTraceletViewController.swift
//  TraceletApp
//
//  Created by Kai Kawasaki Ueda on 3/25/19.
//  Copyright © 2019 Kai Kawasaki Ueda. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class CodigoTraceletViewController : UIViewController, UITextFieldDelegate{
    
    var name:String = ""
    var email:String = ""
    var deviceId:String = ""
    
    @IBOutlet weak var traceletIdTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        deviceId = traceletIdTextField.text!
    }
    
    @IBAction func conectTraceletButton(_ sender: Any) {
        if Auth.auth().currentUser != nil {
            let userAuth = Auth.auth().currentUser
            let userUid = userAuth?.uid
            let db = Firestore.firestore()
            deviceId = traceletIdTextField.text!
            
            db.collection("users").document(userUid!).setData([
                "name": name,
                "email": email,
                "deviceId": deviceId,
                "canViewList": [],
                "canModifyList": []
            ]) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                }
            }
            //UserDefaults.standard.set(true, forKey: "status")
            //Switcher.updateRootViewController()
        } else {
            let alertController = UIAlertController(title: "Error with Auth", message: "Please refresh the application.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
}

