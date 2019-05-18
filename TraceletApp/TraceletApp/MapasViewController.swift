//
//  MapasViewController.swift
//  TraceletApp
//
//  Created by ITESM CCM on 3/20/19.
//  Copyright © 2019 Kai Kawasaki Ueda. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Firebase

class MapasViewController: UIViewController, CLLocationManagerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var myMap: MKMapView!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var vitals: UIButton!
    @IBOutlet weak var dropDown: UIPickerView!
    
    
    private var locationManager = CLLocationManager()
    
    var cl = CLLocationCoordinate2DMake(-19.283, -99.136)
    var ref: DatabaseReference!
    
    var mailParser = MailParser()
    
    var userToListen : String = "_"
    
    var list : [String] = []
    let rest = MKPointAnnotation()
    
    override func viewDidLoad() {
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
        
        myMap.mapType = MKMapType.standard
        
        myMap.region = MKCoordinateRegion(center: cl, latitudinalMeters: 2000, longitudinalMeters: 2000)
        
        rest.coordinate = cl
        myMap.addAnnotation(rest)
        
        guard let locValue: CLLocationCoordinate2D = locationManager.location?.coordinate else { return }
        
        let newCLL = locValue
        self.myMap.setCenter(newCLL, animated: true)
        self.rest.coordinate = newCLL
        rest.title = "Current Location of \(self.userToListen)"
        self.myMap.addAnnotation(self.rest)
        
        myMap.showsCompass = true
        myMap.showsScale = true
        myMap.showsTraffic = true
        myMap.isZoomEnabled  = true
        // Do any additional setup after loading the view.
        
        userName.layer.masksToBounds = false
        userName.layer.shadowColor = UIColor.gray.cgColor
        userName.layer.shadowOpacity = 0.3
        userName.layer.shadowOffset = CGSize(width: -2, height: 2)
        userName.layer.shadowRadius = 1
        
        vitals.layer.masksToBounds = false
        vitals.layer.shadowColor = UIColor.gray.cgColor
        vitals.layer.shadowOpacity = 0.3
        vitals.layer.shadowOffset = CGSize(width: -2, height: 2)
        vitals.layer.shadowRadius = 1
        
        self.dropDown.isHidden = true
        
        getCurrentUserInfo() {
            () in
            //print("COMPLETION 1")
        }
        
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getCurrentUserInfo() {
            () in
            print("WILLAPPEAR ------- COMPLETION -> 3")
        }
    }
    
    func getCurrentUserInfo(completed: () -> ()) {
        CurrentUserDB.currentUser.reload() {
            () in
        }
        self.list = CurrentUserDB.currentUser.canModifyList ?? ["_"]
        self.list.insert("\(CurrentUserDB.currentUser.email ?? "_" )", at: 0)
        self.dropDown.reloadAllComponents()
        self.userName.text = CurrentUserDB.currentUser.name
        self.dropDown.reloadInputViews()
        self.userToListen = CurrentUserDB.currentUser.email ?? "_"
        //print("COMPLETION ------- COMPLETION -> 2")
        //print("---------------VIEW COMPLETION----------------")
        //print("self list after RELOAD: \(self.list), new userName: //\(self.userName)")
        //print("----------------------------------------------")
        completed()
    }

    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
            myMap.showsUserLocation = true
        } else {
            locationManager.stopUpdatingLocation()
            myMap.showsUserLocation = false
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            self.myMap.setRegion(region, animated: true)
        }
        
        guard let locValue: CLLocationCoordinate2D = locationManager.location?.coordinate else { return }
        
        let newCLL = locValue
        self.myMap.setCenter(newCLL, animated: true)
        self.rest.coordinate = newCLL
        let userName = mailParser.decode(self.userToListen)
        self.rest.title = "Current Location of \(userName)"
        self.myMap.addAnnotation(self.rest)
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        
        if list != nil{
            return list.count
        } else {
            return 0
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        self.view.endEditing(true)
        return list[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        changeLocationToUserNow()
        let userSelected = self.list[row]
        self.userName.text = userSelected
        self.dropDown.isHidden = true
        print("Row selected \(self.list[row])")
        
        self.userToListen = userSelected
        changeLocationToUser()
    }
    
    func changeLocationToUserNow() {
        
        userToListen = mailParser.encode(userToListen)
        let ref = Database.database().reference(withPath: "usrs/\(userToListen)/location")
        ref.observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            if (snapshot.exists()) {
                //print("SNAPSHOT CHILD COUNT A: \(snapshot.childrenCount)")
                let snapDict = snapshot.value as? [String: Double] ?? [:]
                
                if snapDict != [:] && snapshot.childrenCount == 2 {
                    //print("SNAPSHOT A: \(snapshot) SNAPDICT A: \(snapDict)")
                    let newCLL = CLLocationCoordinate2D(latitude: snapDict["x"]!, longitude: snapDict["y"]!)
                    self.myMap.setCenter(newCLL, animated: true)
                    self.rest.coordinate = newCLL
                    let userName = self.mailParser.decode(self.userToListen)
                    self.rest.title = "Current Location of \(userName)"
                    self.myMap.addAnnotation(self.rest)
                    //`print("SNAPSHOT A: \(snapshot) SNAPDICT A: \(snapDict)")
                }
                
                //self.myMap.center = CGPoint(x: snapDict["x"]!, y: snapDict["y"]!)
            } else {
                print("SNAPSHOT NOT FOUND ERROR")
            }
        })
    }
    
    func changeLocationToUser() {
        userToListen = mailParser.encode(userToListen)
        // ref = Database.database().reference().child("usrs/\(userToListen)")
        let ref = Database.database().reference(withPath: "usrs/\(userToListen)")
        ref.observe(DataEventType.childChanged, with: { (snapshot) in
            if (snapshot.exists()) {
                //print("SNAPSHOT CHILD COUNT A: \(snapshot.childrenCount)")
                let snapDict = snapshot.value as? [String: Double] ?? [:]
                
                if snapDict != [:] && snapshot.childrenCount == 2 {
                    //print("SNAPSHOT A: \(snapshot) SNAPDICT A: \(snapDict)")
                    let newCLL = CLLocationCoordinate2D(latitude: snapDict["x"]!, longitude: snapDict["y"]!)
                    self.myMap.setCenter(newCLL, animated: true)
                    self.rest.coordinate = newCLL
                    let userName = self.mailParser.decode(self.userToListen)
                    self.rest.title = "Current Location of \(userName)"
                    self.myMap.addAnnotation(self.rest)
                    //`print("SNAPSHOT A: \(snapshot) SNAPDICT A: \(snapDict)")
                }
                
                //self.myMap.center = CGPoint(x: snapDict["x"]!, y: snapDict["y"]!)
            } else {
                print("SNAPSHOT NOT FOUND ERROR")
            }
        })
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == self.userName {
            self.dropDown.isHidden = false
            //if you don't want the users to se the keyboard type:
            
            textField.endEditing(true)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is SignosVitalesViewController {
            let vc = segue.destination as? SignosVitalesViewController
            vc?.userToListenTo = self.userToListen
        }
    }

}
