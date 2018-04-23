//
//  EventViewController.swift
//  CookieMeUp
//
//  Created by Regie Daquioag on 3/27/18.
//  Copyright © 2018 Regie Daquioag. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps

class EventViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    var events: [simpleEvent] =  []
    var dataEvent: [simpleEvent] = []
    var dataDist: [Double?] = []
    var sortedEvents: [Double: [simpleEvent]] = [:]
    var userLocation: CLLocation?
    let cellIdentifier = "BuyerEventCell"
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()

        // Do any additional setup after loading the view.
//            let distanceMiles = (userLocation?.distance(from: item!))! / 1609.34
   
        for event in events{
            let distance = (userLocation?.distance(from: event.location!))! / 1609.34
            event.distance = distance
            if sortedEvents[distance] != nil {
                var array = sortedEvents[distance]
                array?.append(event)
                sortedEvents[distance] = array
            }else{
                let array = [event]
                sortedEvents[distance] = array
            }
        }
        let sortedDict = sortedEvents.sorted(by: { $0.0 < $1.0 })
        for(key,value) in sortedDict{
            for item in value{
                dataEvent.append(item)
                dataDist.append(key)
            }
        }

    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! BuyerEventCell
        let info = dataEvent[indexPath.row]
        var addressAra = info.adressLabel?.components(separatedBy: ",")
        
        let time = info.dateString?.components(separatedBy: " ")
        let dateString = time![2].components(separatedBy: "/")
        var monthName: String?
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
        addressAra![1].remove(at: addressAra![1].startIndex)
        let fullDate = monthName! + " " + dateString[1]
        let secondPart = "," + dateString[2] + " @ " + time![0] + " " + time![1]
        let fullCity = addressAra![1] + "," + addressAra![2]
       
        cell.cityLabel.text = fullCity
        cell.streetAdressLabel.text = addressAra![0]
        cell.dateLabel.text = fullDate + secondPart
        cell.distanceLabel.text = String(format:"%.1f", dataDist[indexPath.row]!) + "mi"
        
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return dataEvent.count
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
