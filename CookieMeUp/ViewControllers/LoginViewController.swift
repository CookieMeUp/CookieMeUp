//
//  LoginViewController.swift
//  CookieMeUp
//
//  Created by Daniel Calderon on 3/25/18.
//  Copyright © 2018 Daniel Calderon. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextView: UITextField!
    @IBOutlet weak var passwordTextView: UITextField!
    let alertController = UIAlertController(title: "Alert", message: "Missing Password and/or Username", preferredStyle: .alert)
    override func viewDidLoad() {
        super.viewDidLoad()

        //Setting up the Alert Controller
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
        }
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
        }
        alertController.addAction(cancelAction)
        alertController.addAction(OKAction)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func onTapSignIn(_ sender: Any) {
        if let email = self.emailTextView.text, let password = self.passwordTextView.text {
                // [START headless_email_auth]
                Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                    // [START_EXCLUDE]
                        if let error = error {
                            self.alertController.message = error.localizedDescription
                            self.present(self.alertController, animated: true) {
                            }
                            return
                        }
                    let newViewController = self.storyboard?.instantiateViewController(withIdentifier: "InitialSellerScreen")
                    
                    // your code
                    
                    self.present(newViewController!, animated: true, completion: nil)
                    // [END_EXCLUDE]
                }
                // [END headless_email_auth]
        } else {
            self.alertController.message = "Password Or Email Field Cannot Be Empty."
            present(alertController, animated: true) {
            }
        }
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
