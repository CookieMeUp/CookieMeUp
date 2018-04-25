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
    @IBOutlet weak var submitChanges: UIButton!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var descriptionView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()

        descriptionView.layer.cornerRadius = 5.0
        descriptionView.layer.borderWidth = 1.0
        descriptionView.layer.borderColor = UIColor(red: 114/255.0, green: 45/255.0, blue: 45/255.0, alpha: 1.0).cgColor
        dateLabel.text = formatDate(date: event.dateString)
        addressLabel.text = formatAddress(address: event.address)
        descriptionView.text = event.description
        submitChanges.layer.cornerRadius = 10
        submitChanges.clipsToBounds = true
        // Do any additional setup after loading the view.
    }
    func formatAddress(address: String?) -> String{
        var addressAra = address?.components(separatedBy: ",")
        var resultString: String?
        resultString = addressAra![0] + "\n"
        
        addressAra![1].remove(at: addressAra![1].startIndex)
        resultString = resultString! + addressAra![1] + "," + addressAra![2]
        return resultString!
    }
    func dateTimePicker(_ picker: DateTimePicker, didSelectDate: Date) {
        
        dateLabel.text = formatDatePicker(date: picker.selectedDateString)
        event.dateString = picker.selectedDateString
    }
    func formatDatePicker(date: String?) -> String {
        let time = date?.components(separatedBy: " ")
        let dateString = time![2].components(separatedBy: "/")
        var date: String?
        var monthName: String?
        
        switch (dateString[1]){
        case "01":
            monthName = "January"
            break
        case "02":
            monthName = "February"
            break
        case "03":
            monthName = "March"
            break
        case "04":
            monthName = "April"
            break
        case "05":
            monthName = "May"
            break
        case "06":
            monthName = "June"
            break
        case "07":
            monthName = "July"
            break
        case "08":
            monthName = "August"
            break
        case "09":
            monthName = "September"
            break
        case "10":
            monthName = "October"
            break
        case "11":
            monthName = "November"
            break
        case "12":
            monthName = "December"
            break
        default:
            monthName = ""
            break
        }
        let secondPart = "," + dateString[2] + " @ " + time![0] + " " + time![1]
        print(monthName)
        date = monthName!
        date = date! + " "
        date = date! + dateString[0]
        date = date! + secondPart
        print(date)
        return date!
    }
    func formatDate(date: String?) -> String {
        let time = date?.components(separatedBy: " ")
        let dateString = time![2].components(separatedBy: "/")
        var date: String?
        var monthName: String?
        print(time)
        print(dateString)
        switch (dateString[0]){
        case "01":
            monthName = "January"
            break
        case "02":
            monthName = "February"
            break
        case "03":
            monthName = "March"
            break
        case "04":
            monthName = "April"
            break
        case "05":
            monthName = "May"
            break
        case "06":
            monthName = "June"
            break
        case "07":
            monthName = "July"
            break
        case "08":
            monthName = "August"
            break
        case "09":
            monthName = "September"
            break
        case "10":
            monthName = "October"
            break
        case "11":
            monthName = "November"
            break
        case "12":
            monthName = "December"
            break
        default:
            monthName = ""
            break
        }
        let secondPart = "," + dateString[2] + " @ " + time![0] + " " + time![1]

        date = monthName!
        date = date! + " "
        date = date! + dateString[1]
        date = date! + secondPart
        print(date)
        return date!
    }
    @IBAction func onTapDate(_ sender: Any) {
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
        picker.dateFormat = "hh:mm aa dd/MM/YYYY"
        //        picker.isTimePickerOnly = true
        picker.includeMonth = false // if true the month shows at top
        picker.completionHandler = { date in
            let formatter = DateFormatter()
            formatter.dateFormat = "hh:mm aa dd/MM/YYYY"
        }
        picker.delegate = self
        self.picker = picker
    }
    @IBAction func onTapSubmit(_ sender: Any) {
        print("Adding cahnges")
        let user = Auth.auth().currentUser
        let ref = Database.database().reference()
        let firebaseEvent = ["latitude" : event.latitude!, "longitude": event.longitute!, "address": event.address!,"dateString": event.dateString!,"id": event.randomId!,"firebaseUid": event.firebaseUID!,"description": descriptionView.text] as [String : Any]
        ref.child("users").child((user?.uid)!).child("events").child(self.event.randomId!).setValue(firebaseEvent)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let feedViewController = storyboard.instantiateViewController(withIdentifier: "InitialSellerScreen")
        self.present(feedViewController, animated: true, completion: nil)


        
    }
    
    
    @IBAction func onTapAddress(_ sender: UITapGestureRecognizer) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        autocompleteController.tableCellBackgroundColor =  UIColor(red: 249/255.0, green: 228/255.0, blue: 200/255.0, alpha: 1.0)
        autocompleteController.tableCellSeparatorColor = UIColor(red: 114/255.0, green: 45/255.0, blue: 45/255.0, alpha: 1.0)
        autocompleteController.primaryTextColor = UIColor(red: 216/255.0, green: 100/255.0, blue: 73/255.0, alpha: 1.0)
        autocompleteController.secondaryTextColor = UIColor(red: 154/255.0, green: 105/255.0, blue: 73/255.0, alpha: 1.0)

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
        addressLabel.text = formatAddress(address: place.formattedAddress)
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
