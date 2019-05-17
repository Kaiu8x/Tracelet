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
    
    var cl = CLLocationCoordinate2DMake(0.0, 0.0)
    var ref: DatabaseReference!
    
    var mailParser = MailParser()
    
    var list : [String] = []
    let rest = MKPointAnnotation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //DispatchQueue.global().async {
        DispatchQueue.main.async {
            self.list = CurrentUserDB.currentUser.canModifyList ?? ["_"]
            self.dropDown.reloadAllComponents()
            self.userName.text = CurrentUserDB.currentUser.name
            self.dropDown.reloadInputViews()
            print("self list after RELOAD: \(self.list), new userName: \(self.userName)")
        }
        
        CurrentUserDB.currentUser.reload{
            self.list = CurrentUserDB.currentUser.canModifyList ?? ["_"]
            self.dropDown.reloadAllComponents()
            self.userName.text = CurrentUserDB.currentUser.name
            self.dropDown.reloadInputViews()
            print("self list after RELOAD: \(self.list), new userName: \(self.userName)")
        }
        
        
        // func to get data from real persons.
        
        /*
        ref = Database.database().reference()
        
        var userAuthEmail = Auth.auth().currentUser?.email
        
        userAuthEmail = mailParser.encode(userAuthEmail!)
        
        self.userName.text = CurrentUserDB.currentUser.name
        
        
        /*ref = Database.database().reference()
        
        print("child ref: usrs/\(userAuthEmail!)/location/x")
        
        ref.child("usrs/\(userAuthEmail!)/location/x").setValue(locValue.latitude)
        
        print("child ref: usrs/\(userAuthEmail!)/location/y")
        
        ref.child("usrs/\(userAuthEmail!)/location/y").setValue(locValue.longitude)
        if CurrentUserDB.currentUser.location != nil {
            CurrentUserDB.currentUser.location![dateString] = "(\(locValue.latitude),\(locValue.longitude))"
        }*/
        
            let refLocation = ref.child("usrs//\(userAuthEmail!)/")
        
            refLocation.observe(Firebase.DataEventType.childChanged , with: { (snapshot) in
            
            let data = snapshot.value
            print("RES OF SNAP \(snapshot.exists())")
            
            //snapshot.didChangeValue(forKey: "location")
            print("SNAPSHOT VALUE: \(snapshot.value)")
                
            if snapshot.value != nil {
                 self.cl.latitude = snapshot.childSnapshot(forPath: "usrs/\(userAuthEmail!)/location/x").value as! CLLocationDegrees
                
                self.cl.longitude = snapshot.childSnapshot(forPath: "usrs/\(userAuthEmail!)/location/y").value as! CLLocationDegrees
                
                print("data changed from realtime: ( \(self.cl.latitude), \(self.cl.longitude) )")
            } else {
                /*let alertController = UIAlertController(title: "Error", message: "User location not found", preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
                 */
            }
        })*/
        
        
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
        
        myMap.mapType = MKMapType.standard
        
        //myMap.region = MKCoordinateRegion(center: cl, latitudinalMeters: 2000, longitudinalMeters: 2000)
        
        //rest.coordinate = cl
        //rest.title = "Current Location"
        
        //myMap.addAnnotation(rest)
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
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        DispatchQueue.global().async {
            self.list = CurrentUserDB.currentUser.canModifyList ?? ["_"]
            print("self list after RELOAD of View: \(self.list), new userName: \(self.userName)")
        }
        self.userName.text = CurrentUserDB.currentUser.name
        self.dropDown.reloadAllComponents()
        self.dropDown.reloadInputViews()
        
        CurrentUserDB.currentUser.reload{
            self.list = CurrentUserDB.currentUser.canModifyList ?? ["_"]
            self.dropDown.reloadAllComponents()
            self.userName.text = CurrentUserDB.currentUser.name
            self.dropDown.reloadInputViews()
            print("self list after RELOAD of View: \(self.list), new userName: \(self.userName)")
        }
        
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
        
        self.userName.text = self.list[row]
        self.dropDown.isHidden = true
        print("Row selected \(self.list[row])")
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

}
