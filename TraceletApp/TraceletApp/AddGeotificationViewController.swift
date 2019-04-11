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

protocol AddGeotificationViewControllerDelegate {
    func addGeotificationViewController(_ controller: AddGeotificationViewController, didAddCoordinate coordinate: CLLocationCoordinate2D,
                                        radius: Double, identifier: String, note: String, eventType: Geotification.EventType)
}



class AddGeotificationViewController: UIViewController, CLLocationManagerDelegate {
    
    
    @IBAction func cancelarButton(_ sender: Any) {
        performSegue(withIdentifier: "unwindToGeofence", sender: self)
    }
    
    
    @IBOutlet weak var userTF: UITextField!
    @IBOutlet weak var radiusTF: UITextField!
    @IBOutlet weak var mapaEG: MKMapView!
    @IBOutlet var addGeofence: UIButton!
    @IBOutlet var nearMe: UIBarButtonItem!
    
    var delegate: AddGeotificationViewControllerDelegate?
    
    private let locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Was changed
        navigationItem.rightBarButtonItems = [addGeofence, nearMe] as? [UIBarButtonItem]
        addGeofence.isEnabled = false
        
        
        self.hideKeyboardWhenTappedAround()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        locationManager.requestWhenInUseAuthorization()
        
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
        // Do any additional setup after loading the view.
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
            mapaEG.showsUserLocation = true
        } else {
            locationManager.stopUpdatingLocation()
            mapaEG.showsUserLocation = false
        }
    }
    
    
    @IBAction func textFieldEditingChanged(_ sender: Any) {
        addGeofence.isEnabled = !radiusTF.text!.isEmpty && !userTF.text!.isEmpty
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    @IBAction func onAdd(_ sender: Any) {
        let coordinate = mapaEG.centerCoordinate
        let radius = Double(radiusTF.text!) ?? 0
        let identifier = NSUUID().uuidString
        let note = userTF.text
        delegate?.addGeotificationViewController(self, didAddCoordinate: coordinate, radius: radius, identifier: identifier, note: note!, eventType: Geotification.EventType.onEntry)
        performSegue(withIdentifier: "unwindToGeofence", sender: self)
    }
    
}
