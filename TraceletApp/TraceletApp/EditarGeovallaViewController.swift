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

class AddGeotificationViewController: UIViewController, CLLocationManagerDelegate {


    @IBAction func cancelarButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
     
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var radiusTF: UITextField!
    @IBOutlet weak var notify: UISwitch!
    @IBOutlet weak var mapaEG: MKMapView!
    @IBOutlet var addGeofence: UIButton!
    @IBOutlet var nearMe: UIBarButtonItem!
    
    
    
    private let locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Was changed
        navigationItem.rightBarButtonItems = [addGeofence, nearMe] as! [UIBarButtonItem]
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
         addGeofence.isEnabled = !radiusTF.text!.isEmpty && !userName.text!.isEmpty
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
        let note = userName.text
      //  let eventType: Geotification.EventType = (eventTypeSegmentedControl.selectedSegmentIndex == 0) ? .onEntry : .onExit
        delegate?.addGeotificationViewController(self, didAddCoordinate: coordinate, radius: radius, identifier: identifier, note: note!, eventType: eventType)
    }
    
}
