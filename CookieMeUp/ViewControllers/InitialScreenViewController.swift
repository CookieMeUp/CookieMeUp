//
//  InitialScreenViewController.swift
//  CookieMeUp
//
//  Created by Daniel Calderon on 3/25/18.
//  Copyright © 2018 Daniel Calderon. All rights reserved.
//

import UIKit

class InitialScreenViewController: UIViewController {
    @IBOutlet weak var buyerBUtton: UIButton!
    @IBOutlet weak var sellerBUtton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buyerBUtton.layer.cornerRadius = 10
        sellerBUtton.layer.cornerRadius = 10

        // Do any additional setup after loading the view.
    }
    @IBAction func onTapBuyer(_ sender: Any) {
        
    }
    @IBAction func onTapSeller(_ sender: Any) {
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationController?.setNavigationBarHidden(false, animated: false)
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
