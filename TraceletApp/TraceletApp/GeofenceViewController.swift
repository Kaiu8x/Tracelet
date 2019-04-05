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

struct PreferencesKeys {
    static let savedItems = "savedItems"
}

class GeofenceViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapaG: MKMapView!
    var geotifications: [Geotification] = []
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        loadAllGeotifications()
        /*
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
        */
        
        
        // Do any additional setup after loading the iew, typically from a nib.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addGeotification" {
            let navigationController = segue.destination as! UINavigationController
            let vc = navigationController.viewControllers.first as! AddGeotificationViewController
            vc.delegate = self
        }
    }
    
    // MARK: Loading and saving functions
    func loadAllGeotifications() {
        geotifications.removeAll()
        let allGeotifications = Geotification.allGeotifications()
        allGeotifications.forEach { add($0) }
    }
    
    func saveAllGeotifications() {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(geotifications)
            UserDefaults.standard.set(data, forKey: PreferencesKeys.savedItems)
        } catch {
            print("error encoding geotifications")
        }
    }
    
    // MARK: Functions that update the model/associated views with geotification changes
    func add(_ geotification: Geotification) {
        geotifications.append(geotification)
        mapView.addAnnotation(geotification)
        addRadiusOverlay(forGeotification: geotification)
        updateGeotificationsCount()
    }
    
    func remove(_ geotification: Geotification) {
        guard let index = geotifications.index(of: geotification) else { return }
        geotifications.remove(at: index)
        mapView.removeAnnotation(geotification)
        removeRadiusOverlay(forGeotification: geotification)
        updateGeotificationsCount()
    }
    
    func updateGeotificationsCount() {
        title = "Geotifications: \(geotifications.count)"
        navigationItem.rightBarButtonItem?.isEnabled = (geotifications.count < 20)
    }
    
    // MARK: Map overlay functions
    func addRadiusOverlay(forGeotification geotification: Geotification) {
        mapView?.add(MKCircle(center: geotification.coordinate, radius: geotification.radius))
    }
    
    func removeRadiusOverlay(forGeotification geotification: Geotification) {
        // Find exactly one overlay which has the same coordinates & radius to remove
        guard let overlays = mapView?.overlays else { return }
        for overlay in overlays {
            guard let circleOverlay = overlay as? MKCircle else { continue }
            let coord = circleOverlay.coordinate
            if coord.latitude == geotification.coordinate.latitude && coord.longitude == geotification.coordinate.longitude && circleOverlay.radius == geotification.radius {
                mapView?.remove(circleOverlay)
                break
            }
        }
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
    
    @IBAction func unwindToGeofenceView(sender: UIStoryboardSegue) {
        
    }
    
}
