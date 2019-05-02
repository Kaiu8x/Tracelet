//
//  UserDetailsViewController.swift
//  TraceletApp
//
//  Created by Kai Kawasaki Ueda on 3/20/19.
//  Copyright © 2019 Kai Kawasaki Ueda. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class UserDetailsViewController : UIViewController {
    
    var userName:String = ""
    var traceletID:String = ""
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var traceletIDLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        setLabels()
    }
    
    func setLabels() {
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(traceletID)
        docRef.getDocument { (document, error) in
            if let document = document {
                self.userNameLabel.text = (document["name"] as! String)
                let s = document["deviceId"] as! String
                self.traceletIDLabel.text = "Tracelet: " + s
                
                print("1 name \(String(describing: self.userNameLabel.text))")
                print("2 device id \(String(describing: self.traceletIDLabel.text))")
            }
        }
    }
}

