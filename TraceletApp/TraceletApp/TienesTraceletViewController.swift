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
    
    var name:String = ""
    var email:String = ""
    var deviceId:String = ""
    
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
            let db = Firestore.firestore()
            var docRef: DocumentReference? = nil
            docRef = db.collection("users").addDocument(data: [
                "name": name,
                "email": email,
                "deviceId": deviceId
            ]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document added with ID: \(docRef!.documentID)")
                }
            }
        }
        
        if let vc = segue.destination as? CodigoTraceletViewController {
            vc.name = name
            vc.email = email
            vc.deviceId = deviceId
        }
        
    }
    
}
