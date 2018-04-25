//
//  LoginViewController.swift
//  CookieMeUp
//
//  Created by Daniel Calderon on 3/25/18.
//  Copyright © 2018 Daniel Calderon. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var emailTextView: SkyFloatingLabelTextField!
    @IBOutlet weak var logInButton: UIButton!
    
    @IBOutlet weak var passwordTextView: SkyFloatingLabelTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        logInButton.layer.cornerRadius = 10
        emailTextView.errorColor = UIColor.red
        self.hideKeyboardWhenTappedAround()

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
                    if error != nil{
                        if let errCode = AuthErrorCode(rawValue: error!._code) {
                            switch errCode{
                                case .invalidEmail:
                                    self.emailTextView.errorMessage = "Invalid Email."
                                case .userNotFound:
                                    self.emailTextView.errorMessage = "User not found."
                                case .wrongPassword:
                                    self.passwordTextView.errorMessage = "Invalid Password"
                                case .emailAlreadyInUse:
                                    self.emailTextView.errorMessage = "Email in use."
                                
                                default: break
                                
                            }
                            return
                        }
                    }
                    let newViewController = self.storyboard?.instantiateViewController(withIdentifier: "InitialSellerScreen")
                    self.present(newViewController!, animated: true, completion: nil)
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

