//
//  SignInViewController.swift
//  Plateforme
//
//  Created by Faten's MacBook  on 20/09/2020.
//  Copyright © 2020 faten hamila. All rights reserved.
//
//this is done
import UIKit
import Alamofire
import SwiftyJSON

class SignInViewController: UIViewController {
    struct User: Codable {
        let id : String
        let username: String
        let email: String
        let password : String
        let role : [String]
    }
    //let encoder = JSONEncoder()
    //let decoder = JSONDecoder()
    let user = User.self

   static var userSignedIn = false
    static var Username : String = ""
    static var UserId : String = ""
    var serverResponse : DataResponse<Any>? = nil

    
    @IBOutlet weak var signinButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var usernameTextField: UITextField!
   
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func signinButtonTapped(_ sender: Any) {
        loginUser()
    }
    
    func  loginUser(){
        
            if (usernameTextField.text == "" || passwordTextField.text == ""){
                errorLabel.text = "please fill in all the blanks"
            }
                
            else {
                let enteredusername = usernameTextField.text!
                let password = self.passwordTextField.text!
                let params : [String : String] = ["username":enteredusername, "password":password]
                
                let url = String(format: "http://localhost:8081/api/auth/signin")
                let headers = [ "Content-Type": "application/json" ]
                
                Alamofire.request(url, method: .post, parameters: params, encoding:JSONEncoding.default, headers: headers)
                 .responseJSON{(response) in
                    self.serverResponse = response
                    // print(response.result.value)
                switch response.result{
                   case .success:
                    if let json = response.result.value as! [String:Any]?{
                        if let idUser = json["id"] as? String {
                            print(idUser)
                            if idUser != ""{
                                SignInViewController.self.UserId = idUser
                                print("the user id  \(SignInViewController.self.UserId)")
                                SignInViewController.self.userSignedIn = true
                                self.showSuccessAlert()

                            }
                        }
                        if let token = json["accessToken"] as? String {
                            print(token)
                        }
                        if let username = json["username"] as? String {
                            print(username)
                            SignInViewController.self.Username = username
                            HomeViewController.self.nameToDisplay = username
                        }
//                        if ( SignInViewController.self.userSignedIn == true){
//                            self.showSuccessAlert()
//                        }
                    }
                case .failure:
                    print ("bad credentials")
                    self.showFailAlert()
                }
                    
            }
    }
    
    }
    func showSuccessAlert(){
    let alert = UIAlertController(title: "Signing in", message: "Welcome back !", preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "Dismiss", style: .default) { (UIAlertAction) -> Void in
            self.navigationController?.popViewController(animated: true)
            self.navigationController?.popViewController(animated: true)

        })
        self.present(alert , animated: true)
    }
    
    func showFailAlert(){
        
        let alert = UIAlertController(title: "Signing in", message: "Signin in failed", preferredStyle: .alert)
                   alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { action in
                           }))
            self.present(alert , animated: true)
}
    func closeView(){
        self.dismiss(animated: true, completion: nil)
    }
    
}

