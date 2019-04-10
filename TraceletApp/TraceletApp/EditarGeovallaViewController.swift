//
//  EditarGeovallaViewController.swift
//  TraceletApp
//
//  Created by kenyiro tsuru on 3/11/19.
//  Copyright © 2019 Kai Kawasaki Ueda. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

protocol AddGeotificationViewControllerDelegate : class {
    func addGeotificationViewController(_ controller: AddGeotificationViewController, didAddCoordinate coordinate: CLLocationCoordinate2D,
                                        radius: Double, identifier: String, note: String, eventType: Geotification.EventType)
}



class AddGeotificationViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet var addGeofence: UIButton!
    @IBOutlet var nearMe: UIBarButtonItem!
    @IBOutlet weak var userTF: UITextField!
    @IBOutlet weak var radiusTF: UITextField!
    @IBOutlet weak var mapaEG: MKMapView!
    
    
    var delegate: AddGeotificationViewControllerDelegate?
    
   // private let locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Was changed
        navigationItem.rightBarButtonItems = [nearMe]
        addGeofence.isEnabled = false
        
        
        /*
        self.hideKeyboardWhenTappedAround() 
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        locationManager.requestWhenInUseAuthorization()
 */
        /*
        mapaEG.mapType = MKMapType.standard
        let cl = CLLocationCoordinate2DMake(19.459415, -99.142667)
        mapaEG.region = MKCoordinateRegion(center: cl, latitudinalMeters: 2000, longitudinalMeters: 2000)
        let rest = MKPointAnnotation()
        rest.coordinate = cl
        rest.title = "Casa"
        //myMap.addAnnotation(rest)
        mapaEG.showsCompass = true
        mapaEG.showsScale = true
        mapaEG.showsTraffic = true
        mapaEG.isZoomEnabled  = true
 */
 
        // Do any additional setup after loading the view.
    }
    
    /*
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
            mapaEG.showsUserLocation = true
        } else {
            locationManager.stopUpdatingLocation()
            mapaEG.showsUserLocation = false
        }
    }
    */
    @IBAction func textFieldEditingChanged(_ sender: Any) {
        addGeofence.isEnabled = !radiusTF.text!.isEmpty && !userTF.text!.isEmpty
    }
    
    @IBAction func onCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onAdd(_ sender: Any) {
        let coordinate = mapaEG.centerCoordinate
        let radius = Double(radiusTF.text!) ?? 0
        let identifier = NSUUID().uuidString
        let note = userTF.text
        delegate?.addGeotificationViewController(self, didAddCoordinate: coordinate, radius: radius,
                                                 identifier: identifier, note: note!, eventType: Geotification.EventType.onEntry)
        //delegate?.addGeotificationViewController(self, didAddCoordinate: coordinate, radius: radius,
        //                                         identifier: identifier, note: note!, eventType: Geotification.EventType.onExit)
        
    }
    
    @IBAction func onZoom(_ sender: Any) {
        mapaEG.zoomToUserLocation()
    }
    
    
    /*
    @IBAction func textFieldEditingChanged(_ sender: Any) {
        addGeofence.isEnabled = !radiusTF.text!.isEmpty && !userTF.text!.isEmpty
    }
    
    @IBAction func onAdd(_ sender: Any) {
        let coordinate = mapaEG.centerCoordinate
        let radius = Double(radiusTF.text!) ?? 0
        let identifier = NSUUID().uuidString
        let note = userTF.text
        delegate?.addGeotificationViewController(self, didAddCoordinate: coordinate, radius: radius, identifier: identifier, note: note!, eventType: Geotification.EventType(rawValue: "On Entry")!)
        delegate?.addGeotificationViewController(self, didAddCoordinate: coordinate, radius: radius, identifier: identifier, note: note!, eventType: Geotification.EventType(rawValue: "On Exit")!)
    }
 */

    
    
}
