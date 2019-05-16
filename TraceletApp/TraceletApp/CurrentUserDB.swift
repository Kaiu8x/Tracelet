//
//  CurrentUserDB.swift
//  TraceletApp
//
//  Created by Kai Kawasaki Ueda on 4/12/19.
//  Copyright © 2019 Kai Kawasaki Ueda. All rights reserved.
//

/*
 
 let now = Date()
 
 let formatter = DateFormatter()
 
 formatter.timeZone = TimeZone.current
 
 formatter.dateFormat = "yyyy-MM-dd HH:mm"
 
 let dateString = formatter.string(from: now)
 
 var userAuthEmail = Auth.auth().currentUser?.email
 userAuthEmail = userAuthEmail?.replacingOccurrences(of: ".", with: ",");
 userAuthEmail = userAuthEmail?.replacingOccurrences(of: "#", with: "_numSign");
 userAuthEmail = userAuthEmail?.replacingOccurrences(of: "$", with: "_dolSign");
 userAuthEmail = userAuthEmail?.replacingOccurrences(of: "[", with: "_leftBrack");
 userAuthEmail = userAuthEmail?.replacingOccurrences(of: "]", with: "_rightBrack");
 
 if Auth.auth().currentUser != nil {
 //print("WRONGGGGGGGGG")
 ref = Database.database().reference()
 
 print("child ref: usrs/\(userAuthEmail!)/location/x")
 
 ref.child("usrs/\(userAuthEmail!)/location/x").setValue(locValue.latitude)
 
 print("child ref: usrs/\(userAuthEmail!)/location/y")
 
 ref.child("usrs/\(userAuthEmail!)/location/y").setValue(locValue.longitude)
 if CurrentUserDB.currentUser.location != nil {
 CurrentUserDB.currentUser.location![dateString] = "(\(locValue.latitude),\(locValue.longitude))"
 }
 
 }
 
 */

import Foundation
import Firebase
import CoreLocation
import HealthKit
//let currentUser = CurrentUserDB()

class CurrentUserDB {
    
    static let currentUser = CurrentUserDB()
    
    var name: String!
    var email: String!
    var deviceId: String!
    var canViewList: [String]?
    var canModifyList: [String]?
    var timeRepeat: Timer?
    var timeRepeat2: Timer?
    var ref: DatabaseReference!
    //var locationLatitude: Double?
    //var locationLongitude: Double?
    
    var location: [String : String]?
    var heartBeat: [String : Int]?
    
    private init() {
        ref = Database.database().reference()
        
        Auth.auth().addStateDidChangeListener { (auth, user) in
            print("Current user creation auth.currentUser state: \(Auth.auth().currentUser) ")
            if Auth.auth().currentUser != nil {
                let userAuth = Auth.auth().currentUser
                //let userUid = userAuth?.uid
                let userAuthEmail = userAuth?.email
                let db = Firestore.firestore()
                
                let docRef = db.collection("users").document(userAuthEmail!)
                //let docHealthRef = db.collection("users").document(userUid!).collection("health")
                
                // Force the SDK to fetch the document from the cache. Could also specify
                // FirestoreSource.server or FirestoreSource.default.
                //docRef.getDocument (source: .default)
                docRef.getDocument (source: .server) { (document, error) in
                    if let document = document {
                        let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                        self.name = (document["name"] as? String)!
                        self.email = (document["email"] as? String)!
                        self.deviceId = (document["deviceId"] as? String)!
                        print("Current user name and email")
                        print(self.name)
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
                self.timeRepeat = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
                self.timeRepeat = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.getCurrentHealth), userInfo: nil, repeats: true)
                self.location = [String : String]()
                self.heartBeat = [String : Int]()
                
                if(HKHealthStore.isHealthDataAvailable()) {
                    let healthStore = HKHealthStore()
                    let allTypes = Set([HKObjectType.quantityType(forIdentifier: .heartRate)!,
                                        HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!])
                    healthStore.requestAuthorization(toShare: allTypes, read: allTypes) { (success, error) in
                        if !success {
                            // Error
                        }
                        
                    }
                    self.setMostRecentDistance()
                    self.setMostRecentHeartRate()
                }
                
            } else {
                print("Error initiallizing currentUserDB")
            }
        }
    }
    
    @objc func reload(_ completion:  @escaping() -> ()) {
        Auth.auth().addStateDidChangeListener { (auth, user) in
            print("Current user creation RELOAD")
            if Auth.auth().currentUser != nil {
                let userAuth = Auth.auth().currentUser
                //let userUid = userAuth?.uid
                let userAuthEmail = userAuth?.email
                let db = Firestore.firestore()
                
                let docRef = db.collection("users").document(userAuthEmail!)
                //let docHealthRef = db.collection("users").document(userUid!).collection("health")
                
                // Force the SDK to fetch the document from the cache. Could also specify
                // FirestoreSource.server or FirestoreSource.default.
                //docRef.getDocument (source: .default)
                docRef.getDocument (source: .server) { (document, error) in
                    if let document = document {
                        let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                        self.name = (document["name"] as? String)!
                        self.email = (document["email"] as? String)!
                        self.deviceId = (document["deviceId"] as? String)!
                        print("Current user name and email")
                        print(self.name)
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
                self.timeRepeat = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
                self.timeRepeat = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.getCurrentHealth), userInfo: nil, repeats: true)
                self.location = [String : String]()
                self.heartBeat = [String : Int]()
                
                if(HKHealthStore.isHealthDataAvailable()) {
                    let healthStore = HKHealthStore()
                    let allTypes = Set([HKObjectType.quantityType(forIdentifier: .heartRate)!,
                                        HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!])
                    healthStore.requestAuthorization(toShare: allTypes, read: allTypes) { (success, error) in
                        if !success {
                            // Error
                        }
                        
                    }
                    self.setMostRecentDistance()
                    self.setMostRecentHeartRate()
                }
                
            } else {
                print("RELOAD Failure")
            }
        }
        completion()
    }
    
    @objc func update() {
        //print("Lat: \(String(describing: self.location?.latitude)), Long: \(String(describing: self.location?.longitude)) ")
        if Auth.auth().currentUser != nil {
            //print("Updating")
            let userAuth = Auth.auth().currentUser
            //let userUid = userAuth?.uid
            let userAuthEmail = userAuth?.email
            let db = Firestore.firestore()
            let docRef = db.collection("users").document(userAuthEmail!)
            
            docRef.updateData([
                "name":self.name,
                "email": self.email,
                "deviceId":self.deviceId,
                "canViewList":self.canViewList!,
                "canModifyList":self.canModifyList!,
                "locations":self.location!,
                "heatbeats":self.heartBeat!
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                }
            }
        } else {
         //print("Auth error when updating")
        }
    }
    
    @objc func getCurrentHealth() {
        HealthKitSetupAssistant.authorizeHealthKit { (authorized, error) in
            
            guard authorized else {
                let baseMessage = "HealthKit Authorization Failed"
                
                if let error = error {
                    print("\(baseMessage). Reason: \(error.localizedDescription)")
                } else {
                    print(baseMessage)
                }
                return
            }
            self.setMostRecentDistance()
            self.setMostRecentHeartRate()
            //print("HealthKit Successfully Authorized and updating to current health")
            
        }
    }
    
    func setMostRecentHeartRate() {
        guard let heartRateSampleType = HKSampleType.quantityType(forIdentifier: .heartRate) else {
            print("Heart Rate Sample Type is no longer available in HealthKit")
            return
        }
        
        ProfileDataStore.getMostRecentSample(for: heartRateSampleType) { (sample, error) in
            guard let sample = sample else {
                if let error = error {
                    // self.displayAlert(for: error)
                }
                return
            }
            let heartRateInBPM = Int(sample.quantity.doubleValue(for: HKUnit(from: "count/min")))
            if Auth.auth().currentUser != nil {
                self.ref = Database.database().reference()
                var userAuthEmail = Auth.auth().currentUser?.email
                self.ref.child("usrs/\(userAuthEmail!)/bpm").setValue(heartRateInBPM)
                print("realtime bpm added: \(heartRateInBPM)")
            }
        }
    }
    
    func setMostRecentDistance() {
        guard let distanceSampleType = HKSampleType.quantityType(forIdentifier: .distanceWalkingRunning) else {
            print("Distance Walking Running Sample Type is no longer available in HealthKit")
            return
        }
        
        ProfileDataStore.getMostRecentSample(for: distanceSampleType) { (sample, error) in
            guard let sample = sample else {
                if let error = error {
                    // self.displayAlert(for: error)
                }
                return
            }
            
            let distanceInMeters = sample.quantity.doubleValue(for: HKUnit.meter())
            
            if Auth.auth().currentUser != nil {
                self.ref = Database.database().reference()
                    var userAuthEmail = Auth.auth().currentUser?.email
                self.ref.child("usrs/\(userAuthEmail!)/distance").setValue(distanceInMeters)
                print("realtime distance added: \(distanceInMeters)")
            }
            
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
    
    func clean() {
        print("Cleaning state of current user")
        name = "_"
        email = "_"
        deviceId = "_"
        canViewList = ["_"]
        canModifyList = ["_"]
        timeRepeat = nil
        timeRepeat2 = nil
        ref = nil
        location = nil
        heartBeat = nil
    }
    
    func logOut() {
        print("Log out user")
        
        do {
            try Auth.auth().signOut()
            print("signOut1 success")
            print("Sgn out suposed to succes auth.currentuserstate: \(Auth.auth().currentUser)")
        } catch (let error) {
            print("Auth sign out failed: \(error)")
        }
        self.timeRepeat?.invalidate()
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
