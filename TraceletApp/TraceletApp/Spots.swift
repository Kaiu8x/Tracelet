//
//  Spots.swift
//  TraceletApp
//
//  Created by Kai Kawasaki Ueda on 4/10/19.
//  Copyright © 2019 Kai Kawasaki Ueda. All rights reserved.
//
import MapKit

class Spots: NSObject, MKAnnotation {
    
    var title: String?
    var info: String
    var panoImgUrl: String
    var panoVideoUrl: String
    var coordinate: CLLocationCoordinate2D
    
    init(title: String, info: String,panoImgUrl: String, panoVideoUrl: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.info = info
        self.panoImgUrl = panoImgUrl
        self.panoVideoUrl = panoVideoUrl
        self.coordinate = coordinate
        
        super.init()
    }
    
    var subtitle: String? {
        return info
    }
    
    init?(json: [String: Any]) {
        self.title = json["name"] as? String ?? "No Title"
        self.info = json["description"] as! String
        self.panoImgUrl = json["panoImgUrl"] as? String ?? ""
        self.panoVideoUrl = json["panoVideoUrl"] as? String ?? ""
        if let latitude = Double(json["latitude"] as! String),
            let longitude = Double(json["longitude"] as! String) {
            self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        } else {
            self.coordinate = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
        }
    }
    
}
