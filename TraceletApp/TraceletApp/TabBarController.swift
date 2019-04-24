//
//  TabBarController.swift
//  TraceletApp
//
//  Created by Kai Kawasaki Ueda on 3/7/19.
//  Copyright © 2019 Kai Kawasaki Ueda. All rights reserved.
//

import Foundation
import Firebase
import UIKit

class TabBarController: UITabBarController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if Auth.auth().currentUser != nil {
            let userAuth = Auth.auth().currentUser
            let userUid = userAuth?.uid
            let db = Firestore.firestore()
            
            let docRef = db.collection("users").document(userUid!)
            
            // Force the SDK to fetch the document from the cache. Could also specify
            // FirestoreSource.server or FirestoreSource.default.
            docRef.getDocument(source: .cache) { (document, error) in
                if let document = document {
                    let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                    print("Cached document data: \(dataDescription)")
                } else {
                    print("Document does not exist in cache")
                }
            }
            
        } else {
            let alertController = UIAlertController(title: "Error with Auth", message: "Please refresh the application.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    
}
