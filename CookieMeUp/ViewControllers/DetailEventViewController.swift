//
//  DetailEventViewController.swift
//  CookieMeUp
//
//  Created by Ali Fenton on 3/30/18.
//  Copyright © 2018 Ali Fenton. All rights reserved.
//

import UIKit
import DateTimePicker
import GooglePlaces
import Firebase
import FirebaseDatabase

class DetailEventViewController: UIViewController,DateTimePickerDelegate{
    var event: Event!
    var picker: DateTimePicker?
    var selectedLocatoin: CLLocation?
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateLabel.text = event.dateString
        addressLabel.text = event.address
        print(event)
        // Do any additional setup after loading the view.
    }
    func dateTimePicker(_ picker: DateTimePicker, didSelectDate: Date) {
        dateLabel.text = picker.selectedDateString
    }
    @IBAction func onTapDate(_ sender: Any) {
        print("TapDate")
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
    @IBAction func onTapSubmit(_ sender: Any) {
        let user = Auth.auth().currentUser
        let ref = Database.database().reference()
        let firebaseEvent = ["latitude" : event.latitude!, "longitude": event.longitute!, "address": event.address!,"dateString": event.dateString!,"id": event.randomId!] as [String : Any]
        ref.child("users").child((user?.uid)!).child("events").child(self.event.randomId!).setValue(firebaseEvent)
    }
    
    
    @IBAction func onTapAddress(_ sender: UITapGestureRecognizer) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension DetailEventViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        addressLabel.text = place.formattedAddress
        let geoCoder = CLGeocoder()
        
        geoCoder.geocodeAddressString(place.formattedAddress!) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
                else {return}
            self.selectedLocatoin = location
            self.event.latitude = self.selectedLocatoin?.coordinate.latitude
            self.event.longitute = self.selectedLocatoin?.coordinate.longitude
            self.event.address = place.formattedAddress
            print(self.event)

            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}
