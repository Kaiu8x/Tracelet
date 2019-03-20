//
//  GeofenceViewController.swift
//  TraceletApp
//
//  Created by ITESM CCM on 3/20/19.
//  Copyright © 2019 Kai Kawasaki Ueda. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class GeofenceViewController: UIViewController, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @IBOutlet weak var mapaG: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        mapaG.mapType=MKMapType.standard
        let cl=CLLocationCoordinate2DMake(19.459415, -99.142667)
        mapaG.region = MKCoordinateRegion(center: cl, latitudinalMeters: 2000, longitudinalMeters: 2000)
        // let rest = MKPointAnnotation()
        //rest.coordinate = cl
        // rest.title = "Mi casita"
        //mapaG.addAnnotation(rest)
        mapaG.showsCompass = true
        mapaG.showsScale = true
        mapaG.showsTraffic = true
        mapaG.isZoomEnabled = true
        
        
        
        // Do any additional setup after loading the iew, typically from a nib.
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse{
            locationManager.startUpdatingLocation()
            mapaG.showsUserLocation = true
        } else {
            locationManager.stopUpdatingLocation()
            mapaG.showsUserLocation = false
        }
    }
    

    
}
