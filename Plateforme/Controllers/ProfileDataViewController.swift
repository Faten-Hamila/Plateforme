//
//  ProfileDataViewController.swift
//  Plateforme
//
//  Created by Faten's MacBook  on 20/10/2020.
//  Copyright © 2020 faten hamila. All rights reserved.
//

//this is done
import UIKit
import Alamofire
import SwiftyJSON

class ProfileDataViewController: UIViewController {
    var serverResponse : DataResponse<Any>? = nil
    static var userID = ""
    static var id = ""
    static var firstname = ""
    static var lastname = ""
    static var address = ""
    static var dateofbirth = ""
    static var postcode = ""
    static var telephone = ""
    static var region = ""
    static var country = ""
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var firstnamelabel: UILabel!
    
    @IBOutlet weak var lastnamelabel: UILabel!
    
    @IBOutlet weak var addresslabel: UILabel!
    
    @IBOutlet weak var dateofbirthlabel: UILabel!
    @IBOutlet weak var postcodelabel: UILabel!
   
    @IBOutlet weak var regionlabel: UILabel!
    
    @IBOutlet weak var telephonelabel: UILabel!
    
    @IBOutlet weak var countrylabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getProfile()
    }
    
   func  getProfile() {
    
           let url = String(format: "http://localhost:8082/api/profile/5f8edb73e19bda47da71b0ce")
           let headers = [ "Content-Type": "application/json" ]
           
           Alamofire.request(url, method: .get, headers: headers)
            .responseJSON{(response) in
               self.serverResponse = response
              print (response)
              switch response.result{
              case .success:
               if let json = response.result.value as! [String:Any]?{
                   if let id = json["id"] as? String {
                    ProfileDataViewController.self.id = id
                   }
                   if let userID = json["userID"] as? String {
                    ProfileDataViewController.self.userID = userID
                   }
                   if let firstname = json["firstName"] as? String {
                    ProfileDataViewController.self.firstname = firstname
                    self.firstnamelabel.text = firstname
                   }
                   if let lastname = json["lastName"] as? String {
                    ProfileDataViewController.self.lastname = lastname
                    self.lastnamelabel.text = lastname
                   }
                   if let birthdate = json["birthDate"] as? String {
                    ProfileDataViewController.self.dateofbirth = birthdate
                    self.dateofbirthlabel.text = birthdate
                   }
                   if let address = json["address"] as? String {
                    ProfileDataViewController.self.address = address
                    self.addresslabel.text = address
                   }
                   if let postcode = json["postCode"] as? Int {
                    ProfileDataViewController.self.postcode = String (postcode)
                    self.postcodelabel.text = String (postcode)
                   }
                   if let region = json["region"] as? String {
                    ProfileDataViewController.self.region = region
                    self.regionlabel.text = region
                   }
                   if let telephone = json["telephone"] as? Int {
                    ProfileDataViewController.self.telephone = String(telephone)
                    self.telephonelabel.text = String(telephone)
                   }
                   if let country = json["country"] as? String {
                    ProfileDataViewController.self.country = country
                    self.countrylabel.text = country
                   }
               }
              case .failure(let error):
               print (error)
             }
           }

       }
    func updateFields(){

               let url = String(format: "http://localhost:8082/api/profile/5f8edb73e19bda47da71b0ce")
               let headers = [ "Content-Type": "application/json" ]

               Alamofire.request(url, method: .get, headers: headers)
                .responseJSON{(response) in
                   self.serverResponse = response
                  print (response)
                  switch response.result{
                  case .success:
                   if let json = response.result.value as! [String:Any]?{
                       if let id = json["id"] as? String {
                        ProfileDataViewController.self.id = id
                       }
                       if let userID = json["userID"] as? String {
                        ProfileDataViewController.self.userID = userID
                       }
                       if let firstname = json["firstName"] as? String {
                        ProfileDataViewController.self.firstname = firstname
                        self.firstnamelabel.text = firstname
                       }
                       if let lastname = json["lastName"] as? String {
                        ProfileDataViewController.self.lastname = lastname
                        self.lastnamelabel.text = lastname
                       }
                       if let birthdate = json["birthDate"] as? String {
                        ProfileDataViewController.self.dateofbirth = birthdate
                        self.dateofbirthlabel.text = birthdate
                       }
                       if let address = json["address"] as? String {
                        ProfileDataViewController.self.address = address
                        self.addresslabel.text = address
                       }
                       if let postcode = json["postCode"] as? Int {
                        ProfileDataViewController.self.postcode = String (postcode)
                        self.postcodelabel.text = String (postcode)
                       }
                       if let region = json["region"] as? String {
                        ProfileDataViewController.self.region = region
                        self.regionlabel.text = region
                       }
                       if let telephone = json["telephone"] as? Int {
                        ProfileDataViewController.self.telephone = String(telephone)
                        self.telephonelabel.text = String(telephone)
                       }
                       if let country = json["country"] as? String {
                        ProfileDataViewController.self.country = country
                        self.countrylabel.text = country
                       }
                   }

                  case .failure(let error):
                   print (error)
                 }
               }
           }
    override func  viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateFields()
        
    }
       
    func showSuccessAlert(){
    let alert = UIAlertController(title: "Adding profile successed", message: "Your profile is updated ", preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "Dismiss", style: .default) { (UIAlertAction) -> Void in
            self.navigationController?.popViewController(animated: true)
        })
        self.present(alert , animated: true)
    }
    
}
