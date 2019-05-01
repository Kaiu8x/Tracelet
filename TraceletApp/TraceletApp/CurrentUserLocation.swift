//
//  CurrentUserDB.swift
//  TraceletApp
//
//  Created by Kai Kawasaki Ueda on 4/12/19.
//  Copyright © 2019 Kai Kawasaki Ueda. All rights reserved.
//

import Foundation
import Firebase

//let currentUser = CurrentUserDB()

class CurrentUserLocation {
    
    static let currentUserLocation = CurrentUserLocation()
    
    
    var name: String!
    var email: String!
    var deviceId: String!
    var canViewList: [String]?
    var canModifyList: [String]?
    
    
    private init() {
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
                    print(self.name)
                    self.name = (document["name"] as? String)!
                    self.email = (document["email"] as? String)!
                    self.deviceId = (document["deviceId"] as? String)!
                    print("Current user name and email")
                    print(self.name)
                    print(self.email)
                    
                    if(document["canViewList"] != nil) {
                        self.canViewList = (document["canViewList"] as? [String])!
                    } else {
                        self.canViewList = [""]
                    }
                    
                    if(document["canModifyList"] != nil) {
                        self.canModifyList = (document["canViewList"] as? [String])!
                    } else {
                        self.canModifyList = [""]
                    }
                    
                    print("Cached document data: \(dataDescription)")
                } else {
                    print("Document does not exist in cache")
                }
            }
            
        } else {
            print("Error")
        }
}
