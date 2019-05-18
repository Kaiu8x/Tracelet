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
        self.hideKeyboardWhenTappedAround()
        NotificationCenter.default.addObserver(self, selector: #selector(Keyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(Keyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)

    }
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBAction func conectTraceletButton(_ sender: Any) {
        if Auth.auth().currentUser != nil {
            let userAuth = Auth.auth().currentUser
            //let userUid = userAuth?.uid
            let db = Firestore.firestore()
            deviceId = traceletIdTextField.text!
            
            db.collection("users").document(email).setData([
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
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    @objc func Keyboard(notification: Notification){
        let userInfo = notification.userInfo!
        let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification{
            scrollView.contentInset = UIEdgeInsets.zero
        } else {
            scrollView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
        }
        
        scrollView.scrollIndicatorInsets = scrollView.contentInset
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
}

