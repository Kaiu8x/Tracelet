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

class MapasViewController: UIViewController, CLLocationManagerDelegate {

    private let locationManager = CLLocationManager()
    @IBOutlet weak var myMap: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        locationManager.requestWhenInUseAuthorization()
        
        myMap.mapType = MKMapType.standard
        let cl = CLLocationCoordinate2DMake(19.459415, -99.142667)
        myMap.region = MKCoordinateRegion(center: cl, latitudinalMeters: 2000, longitudinalMeters: 2000)
        let rest = MKPointAnnotation()
        rest.coordinate = cl
        rest.title = "Casa"
        myMap.addAnnotation(rest)
        myMap.showsCompass = true
        myMap.showsScale = true
        myMap.showsTraffic = true
        myMap.isZoomEnabled  = true
        // Do any additional setup after loading the view.
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}