//
//  SignUpViewController.swift
//  CookieMeUp
//
//  Created by Daniel Calderon on 3/25/18.
//  Copyright © 2018 Daniel Calderon. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class SignUpViewController: UIViewController,UITextFieldDelegate {
    var ref: DatabaseReference!
    @IBOutlet weak var signUpBUtton: UIButton!
    
    @IBOutlet weak var girlScoutIdTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var firstNameTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var emailTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordTextField: SkyFloatingLabelTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureFirebaseDatabaseReference()
        signUpBUtton.layer.cornerRadius = 10
        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onTapSignUp(_ sender: Any) {
        if let email = self.emailTextField.text, let password = self.passwordTextField.text,let id = girlScoutIdTextField.text{
            //TODO: ONCE ACCESS TO GIRLSCOUT DATABSE WE CAN BEGGIN CHECKING THIS PARt
 
       
            ref.child("GirlScoutIds").observeSingleEvent(of: .value) { (snapshot) in
                let dict = snapshot.value as? [String: AnyObject] ?? [:]
                let values = dict.values as? String
                //TODO: Find Id in Array
                Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                    
                    if error != nil{
                        let errCode = AuthErrorCode(rawValue: error!._code)
                        if errCode == .credentialAlreadyInUse{
                            self.emailTextField.errorMessage = "Email In Use"
                        }
                        if errCode == .missingEmail{
                            self.emailTextField.errorMessage = "Invalid Email"
                        }
                        if errCode == .invalidEmail{
                            self.emailTextField.errorMessage = "Invalid Email"
                        }
                        if errCode == .weakPassword{
                            self.passwordTextField.errorMessage = "At Least 6 Characters"
                        }
                        return
                    }
                    let user = Auth.auth().currentUser;
                    self.ref.child("users").child((user?.uid)!).child("email").setValue(email)
                    self.ref.child("users").child((user?.uid)!).child("id").setValue(id)
                    let newViewController = self.storyboard?.instantiateViewController(withIdentifier: "InitialSellerScreen")
                    
                    // your code
                    
                    self.present(newViewController!, animated: true, completion: nil)
                    
                }
                
            }
        }
    }
    func configureFirebaseDatabaseReference(){
        ref = Database.database().reference()
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
