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
    
    var tapGesture = UITapGestureRecognizer()
    var tapPoint = CGPoint()
    var arrSelectedCoordinates = Array<CLLocationCoordinate2D>()
    var polygon = MKPolygon()
    var isPolygonOverlayActive = true
    var directionsArray: [MKDirections] = []
    var centerCoordinate = CLLocationCoordinate2D()
    
    
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

    
    func setupInitials(){
        
        setupTapGesture()
    }
    
    func setupTapGesture(){
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(createMarker))
        tapGesture.numberOfTapsRequired = 1
        mapView.addGestureRecognizer(tapGesture)
    }
    
    @objc func createMarker(gesture: UITapGestureRecognizer){
        
        tapPoint = gesture.location(in: mapView)
        
        if arrSelectedCoordinates.count < 3{
            
            let tapPoint = gesture.location(in: mapView) // When touch on map view you get the cgpoint on the map
            
            let coordinate = mapView.convert(tapPoint, toCoordinateFrom: mapView) // Then convert cgpoint into coordinates
            
            let annotation = MKPointAnnotation() // Create MKPointAnnotation to give the description of particular point on map
            
            var annotationTitle = "" // Create annotation title varible to assign title to different annotations
            
            switch arrSelectedCoordinates.count {
            case 0:
                annotationTitle = "A"
            case 1:
                annotationTitle = "B"
            case 2:
                annotationTitle = "C"
            default:
                print("No title is required")
            }
            
            annotation.title = annotationTitle // Add title to the MKPointAnnotation
            
            annotation.coordinate = coordinate // Add coordinates to MKPointAnnotation
            
            mapView.addAnnotation(annotation)  // Finally add MKPointAnnotation in the map view
            
            arrSelectedCoordinates.append(coordinate) // Append the selected coordinates
            
            if isPolygonOverlayActive{
                
                if arrSelectedCoordinates.count == 3{
                    
                    createTriangle()
                }
            }
            else{
                
               
            }
        }
        else{
            
            if isPolygonOverlayActive{
                
                let location = CLLocation(latitude: centerCoordinate.latitude, longitude: centerCoordinate.longitude)
                
                let coordinate = mapView.convert(tapPoint, toCoordinateFrom: mapView)
                
                let newLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
                
                print(location.distance(from: newLocation))
                
                if location.distance(from: newLocation) > 10000{
                    
                    mapView.removeOverlay(polygon)
                    
                    for annotation in mapView.annotations{
                        
                        if annotation.coordinate.latitude != 43.6532{
                            
                            if annotation.title != "A"{
                                
                                mapView.removeAnnotation(annotation)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func createTriangle() {
        
        polygon = MKPolygon(coordinates: arrSelectedCoordinates, count: arrSelectedCoordinates.count)
        
        mapView.addOverlay(polygon)
    }
    
    
    
    

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        let lat: CLLocationDegrees = location?.coordinate.latitude ?? 0
        let lng: CLLocationDegrees = location?.coordinate.longitude ?? 0
        
       displayLocation(latitude: lat, longitude: lng, title: "Your are here", subtitle: "Your Location")
    
    
    }
    
}

