//
//  DisplayEventsViewController.swift
//  CookieMeUp
//
//  Created by Regie Daquioag on 3/27/18.
//  Copyright © 2018 Regie Daquioag. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Firebase
import FirebaseDatabase

class DisplayEventsViewController: UIViewController,UITabBarControllerDelegate {
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var mapView: GMSMapView!
    var events: [simpleEvent] = []
   
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 15.0
    // The currently selected place.
    var selectedPlace: GMSPlace?
    let defaultLocation = CLLocation(latitude: -33.869405, longitude: 151.199)
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.delegate = self
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
        placesClient = GMSPlacesClient.shared()        // Do any additional setup after loading the view.
        let camera = GMSCameraPosition.camera(withLatitude: defaultLocation.coordinate.latitude,
                                              longitude: defaultLocation.coordinate.longitude,
                                              zoom: zoomLevel)
        mapView = GMSMapView.map(withFrame: view.bounds, camera: camera)
        mapView.settings.myLocationButton = true
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.isMyLocationEnabled = true
        
        // Add the map to the view, hide it until we've got a location update.
        view.addSubview(mapView)
        mapView.isHidden = true
    }
    func populateMap(){
        //Creating Markers For Events Near user
        let ref = Database.database().reference().child("users")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            for user in value!{
                let userInfo = user.value as? NSDictionary
                if(userInfo!["events"] == nil){
                    continue
                }
                let events = userInfo!["events"] as? NSDictionary
                for(key,value) in events!{
                    let arrayInfo = value as? [String:Any]
                    let event = Event(latitude: arrayInfo!["latitude"] as! Double, longitude: arrayInfo?["longitude"] as! Double, address: arrayInfo!["address"] as! String, firebaseUID: arrayInfo!["firebaseUid"] as! String, dateString: arrayInfo?["dateString"] as? String, randomId: arrayInfo?["id"] as! String)
                    // I have taken a pin image which is a custom image
               
                    
                    //creating a marker view
                    let position = CLLocationCoordinate2D(latitude: event.latitude!, longitude: event.longitute!)
                    let markerLocation = CLLocation(latitude: event.latitude!,longitude: event.longitute!)
                    let marker = GMSMarker(position: position)
                    let id = event.randomId
                    let addressAra = event.address?.components(separatedBy: ",")
                    marker.title = addressAra?[0]
                    marker.snippet = addressAra?[1]
                    marker.map = self.mapView
                    marker.icon = UIImage(named: "biscuit")
                    marker.userData = id
                    let simpleEve = simpleEvent(adressLabel: event.address, location: markerLocation, dateString: event.dateString,referenceId: id)
                    self.events.append(simpleEve)
                    }
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
            let viewController  = tabBarController.viewControllers?[1] as! EventViewController
            viewController.events = self.events
            viewController.userLocation = self.currentLocation

        return true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
extension DisplayEventsViewController: CLLocationManagerDelegate {
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        currentLocation = location
        print("Location: \(location)")
        
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                              longitude: location.coordinate.longitude,
                                              zoom: zoomLevel)
        if mapView.isHidden {
            mapView.isHidden = false
            mapView.camera = camera
            populateMap()
        } else {
            mapView.animate(to: camera)
        }
        

    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            // Display the map using the default location.
            mapView.isHidden = false
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
}
