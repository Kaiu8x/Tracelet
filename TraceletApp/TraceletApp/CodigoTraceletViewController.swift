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

class CodigoTraceletViewController : UIViewController {
    
    var name:String = ""
    var email:String = ""
    var deviceId:String = ""
    
    @IBOutlet weak var traceletIdTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        deviceId = traceletIdTextField.text!
    }
    
    @IBAction func conectTraceletButton(_ sender: Any) {
        let db = Firestore.firestore()
        var docRef: DocumentReference? = nil
        docRef = db.collection("users").addDocument(data: [
            "name": name,
            "email": email,
            "deviceId": traceletIdTextField.text!
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(docRef!.documentID)")
            }
        }
    }
    
}

