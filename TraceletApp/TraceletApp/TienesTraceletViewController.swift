//
//  TienesTraceletViewController.swift
//  TraceletApp
//
//  Created by Kai Kawasaki Ueda on 3/25/19.
//  Copyright © 2019 Kai Kawasaki Ueda. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class TienesTraceletViewController : UIViewController {
    
    var name:String = " "
    var email:String = " "
    var deviceId:String = " "
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    @IBAction func hasTraceletButton(_ sender: Any) {
        self.performSegue(withIdentifier: "hasTraceletSegue", sender: nil)
    }
    
    @IBAction func noTraceletButton(_ sender: Any) {
        self.performSegue(withIdentifier: "noTraceletSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is TabBarController {
            if Auth.auth().currentUser != nil {
                let userAuth = Auth.auth().currentUser
                let userUid = userAuth?.uid
                let db = Firestore.firestore()
                
                db.collection("users").document(userUid!).setData([
                    "name": name,
                    "email": email,
                    "deviceId": "no_device",
                    "canView": [],
                    "canModify": []
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
        
        if let vc = segue.destination as? CodigoTraceletViewController {
            vc.name = name
            vc.email = email
            vc.deviceId = deviceId
        }
        
    }
    
}
