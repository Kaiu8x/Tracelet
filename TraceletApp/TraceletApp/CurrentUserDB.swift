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

class CurrentUserDB {
    
    static let currentUser = CurrentUserDB()
    
    
    var name: String!
    var email: String!
    var deviceId: String!
    var canViewList: [String]?
    var canModifyList: [String]?
    
    
    private init() {
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if Auth.auth().currentUser != nil {
                let userAuth = Auth.auth().currentUser
                let userUid = userAuth?.uid
                let db = Firestore.firestore()
                
                let docRef = db.collection("users").document(userUid!)
                
                // Force the SDK to fetch the document from the cache. Could also specify
                // FirestoreSource.server or FirestoreSource.default.
                //docRef.getDocument (source: .default)
                docRef.getDocument (source: .server) { (document, error) in
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
                            self.canViewList = []
                        }
                        
                        if(document["canModifyList"] != nil) {
                            self.canModifyList = (document["canModifyList"] as? [String])!
                        } else {
                            self.canModifyList = []
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
    }
    
    
    func update() {
        print("Updating")
        
        if Auth.auth().currentUser != nil {
            let userAuth = Auth.auth().currentUser
            let userUid = userAuth?.uid
            let db = Firestore.firestore()
            let docRef = db.collection("users").document(userUid!)
            
            docRef.updateData([
                "name":self.name,
                "email": self.email,
                "deviceId":self.deviceId,
                "canViewList":self.canViewList!,
                "canModifyList":self.canModifyList!
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                }
            }
        } else {
         print("Auth error when updating")
        }
        
    }
    
    func updateAuthEmail(s: String) {
        Auth.auth().currentUser?.updateEmail(to: s) { (err) in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Auth email successfully updated")
            }
        }
    }
    
    func logOut() {
        print("Log out user")
        
        do {
            try Auth.auth().signOut()
        } catch (let error) {
            print("Auth sign out failed: \(error)")
        }
        
    }
    
    func toName(arr: [String]) -> [String] {
        var arrName : [String]
        arrName = []
        
        for name in arr {
            let db = Firestore.firestore()
            let docRef = db.collection("users").document(name)
            docRef.getDocument { (document, error) in
                if let document = document {
                    arrName.append(document["name"] as! String)
                }
            }
        }
        print("arrName \(arrName)")
        return arrName
    }
}
