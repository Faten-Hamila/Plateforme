//
//  SignUpViewController.swift
//  Plateforme
//
//  Created by Faten's MacBook  on 20/09/2020.
//  Copyright © 2020 faten hamila. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SignUpViewController: UIViewController {
    var serverResponse : DataResponse<Any>? = nil
    var userSignedUp = false

    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBOutlet weak var errorLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signupButtonTapped(_ sender: Any) {
        registerUser()
    }
    
    func registerUser(){
        if ( usernameTextField.text == "" || emailTextField.text == "" || passwordTextField.text == "" ){
            errorLabel.text = "please fill in all the blanks"
        }
        else {
            let enteredusername = usernameTextField.text!
            let password = self.passwordTextField.text!
            let email = self.emailTextField.text!
            
            let params : [String : String] = ["username":enteredusername, "password":password, "email":email]
            
           let url = String(format: "http://localhost:8081/api/auth/signup")
            let headers = [ "Content-Type": "application/json" ]
            
            Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
             .responseJSON{(response) in
                self.serverResponse = response
               print (response)
                if let json = response.result.value as! [String: Any]? {
                    print ((json))
                    if let message = json["message"] as? String {
                    print(message)
                        switch message{
                        case "Username is already taken!":
                            self.errorLabel.text = message
                            self.showFailAlert()
                        case "Email is already in use!" :
                            self.errorLabel.text = message
                            self.showFailAlert()
                        case "User registered successfully!":
                            self.userSignedUp = true
                            self.errorLabel.isHidden = true
                            self.showSuccessAlert()
                        default:
                            let error = "unknown error"
                            print (error)
                        }
                    }
                }
                                            
                }
              }
            }
  
    @IBAction func signinButtonTapped(_ sender: Any) {
       
        }
            

//    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
//        if (identifier == "segueToLogin"){
//            if (self.userSignedUp == true){
//        present(SignInViewController(), animated: true, completion: nil)
//            }
//
//        }
//        return true
//    }
    func showSuccessAlert(){
        let alert = UIAlertController(title: "Signing un", message: "Welcome to the family !", preferredStyle: .alert)
            alert.addAction(UIAlertAction.init(title: "Dismiss", style: .default) { (UIAlertAction) -> Void in
                self.navigationController?.popViewController(animated: true)

            })
            self.present(alert , animated: true)
                                                   
        }
        
        func showFailAlert(){
            
            let alert = UIAlertController(title: "Sign up", message: "Signin up failed", preferredStyle: .alert)
                       alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { action in
                               }))
                self.present(alert , animated: true)
    }
        

}

