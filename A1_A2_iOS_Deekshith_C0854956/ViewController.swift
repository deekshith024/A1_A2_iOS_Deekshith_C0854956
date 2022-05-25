//
//  ViewController.swift
//  A1_A2_iOS_Deekshith_C0854956
//
//  Created by Deekshith Reddy on 2022-05-24.
//

import UIKit
import MapKit


class ViewController: UIViewController,  CLLocationManagerDelegate {

    
    @IBOutlet weak var mapView: MKMapView!
    var locationMng = CLLocationManager()
    
    
    @IBOutlet weak var directionButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        directionButton.isHidden = true
        
    
        locationMng.delegate = self
        
        locationMng.desiredAccuracy = kCLLocationAccuracyBest
        locationMng.requestWhenInUseAuthorization()
        locationMng.startUpdatingLocation()
        
      
        let latitude: CLLocationDegrees = 43.64
        let longitude: CLLocationDegrees = -79.38
        displayLocation(latitude: latitude, longitude: longitude, title: "Toronto", subtitle: "Ontario")
        
        let longpress = UILongPressGestureRecognizer(target: self, action: #selector(addLongPress))
        mapView.addGestureRecognizer(longpress)
        
    }
    
    @objc func addLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        let pressPoint = gestureRecognizer.location(in: mapView)
        let coordinate = mapView.convert(pressPoint, toCoordinateFrom: mapView)
        addAnnotation(coordinate: coordinate, title: "Favourite Place", subtitle: "Saved")
    }
    
    func displayLocation(latitude: CLLocationDegrees, longitude: CLLocationDegrees,
                         title: String,
                         subtitle: String)
    {
        let latDelta: CLLocationDegrees = 0.05
        let lngDelta: CLLocationDegrees = 0.05
        let span =  MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lngDelta)
        
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        addAnnotation(coordinate: location, title: title, subtitle: subtitle)
    }
    
    
    func addAnnotation(
        coordinate: CLLocationCoordinate2D,
        title: String,
        subtitle: String
    ) {
        
        let annotation = MKPointAnnotation()
        annotation.subtitle = subtitle
        annotation.title = title
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
        
    }


    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        let lat: CLLocationDegrees = location?.coordinate.latitude ?? 0
        let lng: CLLocationDegrees = location?.coordinate.longitude ?? 0
        
       displayLocation(latitude: lat, longitude: lng, title: "Your are here", subtitle: "Your Location")
        
        
        
    }
    
}

