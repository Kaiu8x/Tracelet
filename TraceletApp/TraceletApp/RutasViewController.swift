//
//  RutasViewController.swift
//  TraceletApp
//
//  Created by ITESM CCM on 3/20/19.
//  Copyright © 2019 Kai Kawasaki Ueda. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class RutasViewController: UIViewController, CLLocationManagerDelegate {

    private let locationManager = CLLocationManager()
    @IBOutlet weak var mapaR: MKMapView!
    var spots: [Spots] = []
    var newArray:[Any]?
    
    let dataUrl = "http://martinmolina.com.mx/201911/data/jsonTracelet/spots360.json"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationAuthorizationStatus()
        loadInitialData()
        mapaR.delegate = self
        //temporal
        //let spot = Spots(title: "ITESM CCM CDT", info: "Calle Puente 222, Coapa, Arboledas del Sur, 14380 Ciudad de México, CDMX.", panoImgUrl: "http://martinmolina.com.mx/201911/data/jsonTracelet/images/cdt360.jpg", panoVideoUrl: "", coordinate: CLLocationCoordinate2D(latitude: 19.2838266, longitude: -99.1384582))
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        locationManager.requestWhenInUseAuthorization()
        
        mapaR.mapType = MKMapType.standard
        let cl = CLLocationCoordinate2DMake(19.2838265, -99.1384583)
        mapaR.region = MKCoordinateRegion(center: cl, latitudinalMeters: 2000, longitudinalMeters: 2000)
        let rest = MKPointAnnotation()
        rest.coordinate = cl
        rest.title = "cl"
        //myMap.addAnnotation(rest)
        mapaR.showsCompass = true
        mapaR.showsScale = true
        mapaR.showsTraffic = true
        mapaR.isZoomEnabled  = true
        // Do any additional setup after loading the view.
        print("viewDidLoad")
        print(newArray)
        print(spots)
        //mapaR.addAnnotation(spot)
        mapaR.addAnnotations(spots)
        
        // Do any additional setup after loading the view.
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
            mapaR.showsUserLocation = true
        } else {
            locationManager.stopUpdatingLocation()
            mapaR.showsUserLocation = false
        }
    }
    
    func loadInitialData() {
        // 1
        print("loading data")
        let url = URL(string: dataUrl)
        let optionalData = try? Data(contentsOf: url!)
        newArray = try! JSONSerialization.jsonObject(with: optionalData!) as? [Any]
        
        print(newArray)
        
        for result in newArray! {
            let obj = result as! [String:Any]
            
            let spot = Spots(json: result as! [String : Any])
            
            spots.append((spot)!)
        }
        
    }
    
    func JSONParseArray(_ string: String) -> [AnyObject]{
        if let data = string.data(using: String.Encoding.utf8) {
            do {
                if let array = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)  as? [AnyObject] {
                    return array
                }
            } catch {
                print("error")
                //handle errors here
            }
        }
        return [AnyObject]()
    }
    
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapaR.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
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

extension RutasViewController: MKMapViewDelegate {
    // 1
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // 2
        guard let annotation = annotation as? Spots else { return nil }
        // 3
        let identifier = "marker"
        var view: MKMarkerAnnotationView
        // 4
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            // 5
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let location = view.annotation as! Spots
        print(location)
        
        var isvideo = false
        if(location.panoImgUrl == ""){
            isvideo = true
        }
        
        
        var contentUrl = ""
        if(isvideo){
            contentUrl = location.panoVideoUrl
        } else {
            contentUrl = location.panoImgUrl
        }
        
        
        
        if(isvideo) {
            let nextView = self.storyboard?.instantiateViewController(withIdentifier: "Spots360") as! Spots360ViewController
            nextView.contentUrl = contentUrl
            nextView.isVideo = isvideo
            print("1")
            //self.navigationController?.pushViewController(nextView, animated: true)
            self.present(nextView, animated: true, completion: nil)
            print("2")
        } else {
            let nextView = self.storyboard?.instantiateViewController(withIdentifier: "Spots360Img") as! Spots360ImgViewController
            nextView.contentUrl = contentUrl
            nextView.isVideo = isvideo
            print("3")
            //self.navigationController?.pushViewController(nextView, animated: true)
            self.present(nextView, animated: true, completion: nil)
            print("4")
        }
        print(isvideo)
        
        
    }
    
}

