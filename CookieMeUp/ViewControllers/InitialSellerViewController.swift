//
//  InitialSellerViewController.swift
//  CookieMeUp
//
//  Created by Ali Fenton on 3/29/18.
//  Copyright © 2018 Ali Fenton. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class InitialSellerViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    var data: [Event] = []
    var ref: DatabaseReference!
    var noDataLabel: UILabel?
    let cellIdentifier = "SellerEventCell"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView()
        let user = Auth.auth().currentUser
        ref = Database.database().reference()
        ref.child("users").child((user?.uid)!).child("events").observeSingleEvent(of: .value) { (snapshot) in
            let events = snapshot.value as? [String: AnyObject] ?? [:]
      
            for item in events{
                let event = Event(latitude: (item.value["latitude"] as? Double)!, longitude: item.value["longitude"] as? Double, address: (item.value["address"] as? String)!, firebaseUID: (user?.uid)!, dateString: item.value["dateString"] as? String,randomId: item.value["id"] as? String, description: item.value["description"] as? String, username: item.value["username"] as? String)
                self.data.append(event)
            }
            self.tableView.reloadData()
            
        }
        
        // Do any additional setup after loading the view.
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! EventCell
        let info = data[indexPath.row]
        var addressAra = info.address?.components(separatedBy: ",")
        
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
        let secondPart = ", " + dateString[2] + " @ " + time![0] + " " + time![1]
        let fullCity = addressAra![1] + "," + addressAra![2]
        cell.cityLabel.text = fullCity
        cell.addressLabel.text = addressAra![0]
        cell.dateLabel.text = fullDate + secondPart
        cell.descriptionLabel.text = info.description
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("hello")
        print(data.count)
        if(data.count == 0){
            noDataLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel?.text          = "You have no events. Click + to create one."
            noDataLabel?.textColor     = UIColor(red: 189/255.0, green: 69/255.0, blue: 41/255.0, alpha: 0.90)
            noDataLabel?.textAlignment = .center
            noDataLabel?.numberOfLines = 0
            noDataLabel?.lineBreakMode = .byWordWrapping
            tableView.backgroundView  = noDataLabel
            tableView.separatorStyle  = .none
            
        }else{
            noDataLabel?.isHidden = true
            tableView.separatorStyle = .singleLine
            
        }
        return data.count
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "createSegue"){
              let vc = segue.destination as! CreateEventViewController
        }else{
            let vc = segue.destination as! DetailEventViewController
            let senderCell = sender as! EventCell
            if let indexPath = tableView.indexPath(for: senderCell){
                vc.event = data[indexPath.row]
            }
        }
    }
    @IBAction func onTapLogout(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            self.navigationController?.popToRootViewController(animated: true)

        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
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
