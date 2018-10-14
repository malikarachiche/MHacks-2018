//
//  SignInandSignUpViewController.swift
//  MHacks StockX
//
//  Created by Nikhil Iyer on 10/13/18.
//  Copyright © 2018 Malik Arachiche. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SignInandSignUpViewController: UIViewController {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var signBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signInAction(_ sender: Any) {
        if(emailTextField.text != "" && passwordTextField.text != "")
        {
            Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (data, error) in
                if let error = error {
                    self.alertcontrollerDisplay(message: "Could not sign in. Please make sure your email and password are correct. Error - \(error)")
                } else {
                    self.performSegue(withIdentifier: "loginSegue", sender: self)
                }
            }
        }
        else{
            self.alertcontrollerDisplay(message: "Please enter username or password")
        }
    }
    
    @IBAction func signUpAction(_ sender: Any) {
        if(emailTextField.text! == ""){
            self.alertcontrollerDisplay(message: "Please enter an email address")
        } else if(passwordTextField.text! == ""){
            self.alertcontrollerDisplay(message: "Please enter a password")
        } else{
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (data, error) in
                if let error = error {
                    self.alertcontrollerDisplay(message: "Cannot register user. Error - \(error)")
                } else {
                    self.performSegue(withIdentifier: "loginSegue", sender: self)
                }
            }
        }
    }
    
    func alertcontrollerDisplay(message: String){
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
