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
                let event = Event(latitude: (item.value["latitude"] as? Double)!, longitude: item.value["longitude"] as? Double, address: (item.value["address"] as? String)!, firebaseUID: (user?.uid)!, dateString: item.value["dateString"] as? String,randomId: item.value["id"] as? String)
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
        cell.addressLabel.text = info.address
        //cell.layer.borderColor = UIColor(red: 216/255.0, green: 100/255.0, blue: 73/255.0, alpha: 1.0).cgColor
        cell.dateLabel.text = info.dateString
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
