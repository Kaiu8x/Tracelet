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
    //var canViewList: [String]?
    //var canModifyList: [String]?
    
    
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
                    //self.canViewList = (document["canViewList"] as? [String])!
                    //self.canModifyList = (document["canModifyList"] as? [String])!
                    print("Cached document data: \(dataDescription)")
                } else {
                    print("Document does not exist in cache")
                }
            }
            
        } else {
            print("Error")
        }
    }
    
    /*
    var name: String?
    var email: String?
    var deviceId: String?
    var canViewList: [CurrentUserDB]?
    var canModifyList: [CurrentUserDB]?
    
    override init() {
        print("object creation called")
        super.init()
        self.getUserData()
    }
    
    init(document: DocumentSnapshot) {
        print("Self created")
        self.name = document["name"] as? String
        self.email = document["email"] as? String
        self.deviceId = document["deviceId"] as? String
        self.canViewList = document["canViewList"] as? [CurrentUserDB]
        self.canModifyList = document["canModifyList"] as? [CurrentUserDB]
        super.init()
    }
    
    func getUserData() {
        print("get user data method called")
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
                    CurrentUserDB(document: document)
                    print("Cached document data: \(dataDescription)")
                } else {
                    print("Document does not exist in cache")
                }
            }
            
        } else {
            print("Error")
        }
    }
    */
    
}

/*
 
 class Spots: NSObject, MKAnnotation {
 
 var title: String?
 var info: String
 var panoImgUrl: String
 var panoVideoUrl: String
 var coordinate: CLLocationCoordinate2D
 
 init(title: String, info: String,panoImgUrl: String, panoVideoUrl: String, coordinate: CLLocationCoordinate2D) {
 self.title = title
 self.info = info
 self.panoImgUrl = panoImgUrl
 self.panoVideoUrl = panoVideoUrl
 self.coordinate = coordinate
 
 super.init()
 }
 
 var subtitle: String? {
 return info
 }
 
 init?(json: [String: Any]) {
 self.title = json["name"] as? String ?? "No Title"
 self.info = json["description"] as! String
 self.panoImgUrl = json["panoImgUrl"] as? String ?? ""
 self.panoVideoUrl = json["panoVideoUrl"] as? String ?? ""
 if let latitude = Double(json["latitude"] as! String),
 let longitude = Double(json["longitude"] as! String) {
 self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
 } else {
 self.coordinate = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
 }
 }
 
 }
 
*/
