//
//  CreateEventViewController.swift
//  CookieMeUp
//
//  Created by Daniel Calderon on 3/25/18.
//  Copyright © 2018 Daniel Calderon. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import GooglePlaces
import GoogleMaps
import DateTimePicker

class CreateEventViewController: UIViewController,DateTimePickerDelegate{
    var placeMark: CLPlacemark?
    var picker: DateTimePicker?
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    var selectedLocation: CLLocation?
    var selectedAdress: String?
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var mapView: GMSMapView!
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 15.0
    // The currently selected place.
    var selectedPlace: GMSPlace?
    let defaultLocation = CLLocation(latitude: -33.869405, longitude: 151.199)
    
    @IBOutlet weak var mapSubView: UIView!
    //Search for Place With Auto Complete
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //GETTING CURRENT LOCATION FOR USER
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
         locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        placesClient = GMSPlacesClient.shared()
        let camera = GMSCameraPosition.camera(withLatitude: defaultLocation.coordinate.latitude,
                                              longitude: defaultLocation.coordinate.longitude,
                                              zoom: zoomLevel)
        mapView = GMSMapView.map(withFrame: mapSubView.bounds, camera: camera)
        mapView.settings.myLocationButton = true
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.isMyLocationEnabled = true
        
        // Add the map to the view, hide it until we've got a location update.
        mapSubView.addSubview(mapView)
        mapView.isHidden = true
        //PROVIDING AUTOCOMPLETE FOR USER SEARCH ADDRESS
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        
        // Put the search bar in the navigation bar.
        searchController?.searchBar.sizeToFit()
        navigationItem.titleView = searchController?.searchBar
        
        // When UISearchController presents the results view, present it in
        // this view controller, not one further up the chain.
        definesPresentationContext = true
        
        // Prevent the navigation bar from being hidden when searching.
        searchController?.hidesNavigationBarDuringPresentation = false
    }
    func zoomToSearchedLocation(){
        let geoCoder = CLGeocoder()

        geoCoder.geocodeAddressString(selectedAdress!) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
                else {return}
            self.selectedLocation = location

                let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                                      longitude: location.coordinate.longitude,
                                                      zoom: self.zoomLevel)
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            marker.title = "Sydney"
            marker.snippet = "Australia"
            marker.map = self.mapView
            if self.mapView.isHidden {
                self.mapView.isHidden = false
                self.mapView.camera = camera
                } else {
                self.mapView.animate(to: camera)
                }
        }
    }
    @IBAction func tapDate(_ sender: Any) {
        let min = Date().addingTimeInterval(-60 * 60 * 24 * 4)
        let max = Date().addingTimeInterval(60 * 60 * 24 * 4)
        let picker = DateTimePicker.show(selected: Date(), minimumDate: min, maximumDate: max)
        picker.timeInterval = DateTimePicker.MinuteInterval.five
        picker.highlightColor = UIColor(red: 255.0/255.0, green: 138.0/255.0, blue: 138.0/255.0, alpha: 1)
        picker.darkColor = UIColor.darkGray
        picker.doneButtonTitle = "!! DONE DONE !!"
        picker.doneBackgroundColor = UIColor(red: 255.0/255.0, green: 138.0/255.0, blue: 138.0/255.0, alpha: 1)
        picker.locale = Locale(identifier: "en_GB")
        
        picker.todayButtonTitle = "Today"
        picker.is12HourFormat = true
        picker.dateFormat = "hh:mm aa dd/MM/YYYY"
        //        picker.isTimePickerOnly = true
        picker.includeMonth = false // if true the month shows at top
        picker.completionHandler = { date in
            let formatter = DateFormatter()
            formatter.dateFormat = "hh:mm aa dd/MM/YYYY"
            self.title = formatter.string(from: date)
        }
        picker.delegate = self
        self.picker = picker
    }
    
    
    func dateTimePicker(_ picker: DateTimePicker, didSelectDate: Date) {
       dateLabel.text = picker.selectedDateString
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onTapCreate(_ sender: Any) {
        let user = Auth.auth().currentUser
        let ref = Database.database().reference()
        let randomID = ref.child("users").child((user?.uid)!).child("events").childByAutoId()
        let newEvent = ["latitude" : (selectedLocation?.coordinate.latitude)!, "longitude": selectedLocation?.coordinate.longitude as Any, "address": selectedAdress!,"dateString": dateLabel.text!,"id": randomID.key,"firebaseUid": user?.uid] as [String : Any]
        ref.child("users").child((user?.uid)!).child("events").child(randomID.key).setValue(newEvent)
        
    }
    
}
extension CreateEventViewController: CLLocationManagerDelegate {
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        selectedLocation = location
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                              longitude: location.coordinate.longitude,
                                              zoom: zoomLevel)
        //Friendly user location
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            // Place details
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            print(placeMark.name)
            var formatAddress: String = ""
            formatAddress = formatAddress + placeMark.name! + ","
            formatAddress = formatAddress + placeMark.locality! + ","
            formatAddress = formatAddress + placeMark.administrativeArea! + ","
            formatAddress = formatAddress + placeMark.postalCode! + ","
            formatAddress = formatAddress + placeMark.country!
  
            self.addressLabel.text = formatAddress
            self.selectedAdress = self.addressLabel.text
        })
        //END
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapView
        if mapView.isHidden {
            mapView.isHidden = false
            mapView.camera = camera
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
extension CreateEventViewController: GMSAutocompleteResultsViewControllerDelegate {
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false

        selectedAdress = place.formattedAddress
        searchController?.searchBar.text = selectedAdress
        addressLabel.text = selectedAdress
        zoomToSearchedLocation()
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: Error){
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
