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
    @IBOutlet weak var calendarButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    
    var placeMark: CLPlacemark?
    var picker: DateTimePicker?
    @IBOutlet weak var dateLabel: UILabel!
    var dPicker: DateTimePicker?
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
    @IBOutlet weak var searchView: UIView!
    
    @IBOutlet weak var mapSubView: UIView!
    //Search for Place With Auto Complete
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        submitButton.layer.cornerRadius = 10
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
        resultsViewController?.tableCellBackgroundColor =  UIColor(red: 249/255.0, green: 228/255.0, blue: 200/255.0, alpha: 1.0)
        resultsViewController?.tableCellSeparatorColor = UIColor(red: 114/255.0, green: 45/255.0, blue: 45/255.0, alpha: 1.0)
        resultsViewController?.primaryTextColor = UIColor(red: 216/255.0, green: 100/255.0, blue: 73/255.0, alpha: 1.0)
        resultsViewController?.secondaryTextColor = UIColor(red: 154/255.0, green: 105/255.0, blue: 73/255.0, alpha: 1.0)
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        searchController?.searchBar.backgroundImage = UIImage()
        searchController?.searchBar.placeholder = "Event Address"
        searchView.addSubview((searchController?.searchBar)!)
        searchController?.searchBar.sizeToFit()
        searchController?.hidesNavigationBarDuringPresentation = false
        
        
        // When UISearchController presents the results view, present it in
        // this view controller, not one further up the chain.
        definesPresentationContext = true
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
            let placeMark = placemarks.first as? CLPlacemark
            marker.position = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            marker.title = placeMark?.name
            marker.snippet = placeMark?.locality
            marker.map = self.mapView
            marker.icon = UIImage(named: "biscuit")
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

        picker.highlightColor = UIColor(red: 189/255.0, green: 69/255.0, blue: 41/255.0, alpha: 0.90)
        picker.darkColor = UIColor.darkGray
        picker.doneButtonTitle = "DONE"
        picker.doneBackgroundColor = UIColor(red: 189/255.0, green: 69/255.0, blue: 41/255.0, alpha: 0.90)
        picker.locale = Locale(identifier: "en_GB")
        
        picker.todayButtonTitle = "Today"
        picker.is12HourFormat = true
        picker.dateFormat = "hh:mm aa MM/dd/YYYY"
        //        picker.isTimePickerOnly = true
        picker.includeMonth = false // if true the month shows at top
        picker.completionHandler = { date in
            let formatter = DateFormatter()
            formatter.dateFormat = "hh:mm aa MM/dd/YYYY"
        }
        picker.delegate = self
        self.picker = picker
    }
    
    
    func dateTimePicker(_ picker: DateTimePicker, didSelectDate: Date) {
        dPicker = picker
        dateLabel.text = picker.selectedDateString
        dateLabel.textColor = UIColor(red: 189/255.0, green: 69/255.0, blue: 41/255.0, alpha: 0.90)
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
        ref.child("users").child((user?.uid)!).child("events").observeSingleEvent(of: .value) { (snapshot) in
            let events = snapshot.value as? [String: AnyObject] ?? [:]
            let formatter = DateFormatter()
            formatter.dateFormat = "hh:mm aa MM/dd/YYYY"
            formatter.locale = Locale(identifier: "en_GB")
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            for item in events{
                let date = formatter.date(from: item.value["dateString"] as! String)
                let newEventDate = formatter.date(from: (self.dPicker?.selectedDateString)!)
                print("Getting differencet")
                print(formatter.date(from: item.value["dateString"] as! String)!)
                print(newEventDate?.timeIntervalSince(date!))
                let timePassed = newEventDate?.timeIntervalSince(date!) as! Double
                if( item.value["latitude"] as? Double == newEvent["latitude"] as? Double && item.value["longitude"] as? Double == newEvent["longitude"] as? Double &&  timePassed < 1800.00){
                    print("NotMkaingEvent")
                    return
                }else{
                    ref.child("users").child((user?.uid)!).child("events").child(randomID.key).setValue(newEvent)
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let feedViewController = storyboard.instantiateViewController(withIdentifier: "InitialSellerScreen")
                    self.present(feedViewController, animated: true, completion: nil)
                }
            }
            ref.child("users").child((user?.uid)!).child("events").child(randomID.key).setValue(newEvent)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let feedViewController = storyboard.instantiateViewController(withIdentifier: "InitialSellerScreen")
            self.present(feedViewController, animated: true, completion: nil)
        }

        
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
            
            self.selectedAdress = formatAddress
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            marker.title = placeMark?.name
            print("Adding snipper")
            marker.snippet = placeMark?.locality
            marker.icon = UIImage(named: "biscuit")
            marker.map = self.mapView
            if self.mapView.isHidden {
                self.self.mapView.isHidden = false
                self.mapView.camera = camera
            } else {
                self.mapView.animate(to: camera)
            }
        })
        //END

        
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
              self.searchController?.searchBar.frame.size.width = self.searchView.frame.size.width
        searchController?.isActive = false
        
        selectedAdress = place.formattedAddress
        searchController?.searchBar.text = selectedAdress
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
