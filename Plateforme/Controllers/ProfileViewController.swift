//
//  ProfileViewController.swift
//  Plateforme
//
//  Created by Faten's MacBook  on 09/10/2020.
//  Copyright © 2020 faten hamila. All rights reserved.
//

//this is done
import UIKit
import Alamofire
import SwiftyJSON

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    var serverResponse : DataResponse<Any>? = nil
    var id = ""
    var profileuserID = ""
   static var profileIsSet = false
    static var profileisupdated = false
    var idProfile = ProfileDataViewController.self.id

    static var UserId = SignInViewController.self.UserId
    struct User : Codable {
        var id : String
        var userID : String
        var firstname : String
        var lastname : String
        var birthDate : Date
        var adress : String
        var postcode : Int8
        var region : String
        var telephone: Int8
        var country : String
        var idCompetence : String
        
    }
    
    var imagePicker = UIImagePickerController()
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var firstnameTextField: UITextField!
    @IBOutlet weak var lastnameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var dateofbirthTextField: UITextField!
    @IBOutlet weak var postcodeTextField: UITextField!
    @IBOutlet weak var regionTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var telephoneTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstnameTextField.delegate = self
        lastnameTextField.delegate = self
        addressTextField.delegate = self
        dateofbirthTextField.delegate = self
        postcodeTextField.delegate = self
        regionTextField.delegate = self
        countryTextField.delegate = self
        telephoneTextField.delegate = self
        imagePicker.delegate = self
        firstnameTextField.placeholder = ProfileDataViewController.self.firstname
        lastnameTextField.placeholder = ProfileDataViewController.self.lastname
        dateofbirthTextField.placeholder = ProfileDataViewController.self.dateofbirth
        addressTextField.placeholder = ProfileDataViewController.self.address
        
        postcodeTextField.placeholder = ProfileDataViewController.self.postcode
        regionTextField.placeholder = ProfileDataViewController.self.region
        telephoneTextField.placeholder =  ProfileDataViewController.self.telephone
        countryTextField.placeholder =  ProfileDataViewController.self.country
        
    }
    
    func updateProfile(){
        print ("this is update" )
        print (self.idProfile)
        let params =
            ["userID": ProfileViewController.self.UserId != ""  ? ProfileViewController.self.UserId : ProfileDataViewController.self.userID ,
            "id": self.idProfile,
            "firstName": self.firstnameTextField.text != "" ? self.firstnameTextField.text! : ProfileDataViewController.self.firstname ,
            "lastName": self.lastnameTextField.text != "" ? self.lastnameTextField.text! : ProfileDataViewController.self.lastname ,
            "birthDate": self.dateofbirthTextField.text != "" ? self.dateofbirthTextField.text! : ProfileDataViewController.self.dateofbirth ,
            "address": self.addressTextField.text != "" ? self.addressTextField.text! : ProfileDataViewController.self.address ,
            "postCode":self.postcodeTextField.text != "" ? self.postcodeTextField.text! : ProfileDataViewController.self.postcode,
            "region": self.regionTextField.text != "" ? self.regionTextField.text! : ProfileDataViewController.self.region,
            "telephone": self.telephoneTextField.text != "" ? self.telephoneTextField.text! : ProfileDataViewController.self.telephone ,
            "country": self.countryTextField.text != "" ? self.countryTextField.text! : ProfileDataViewController.self.country,
            "idCompetence": ""] as [String : Any]
        let url = String(format: "http://localhost:8082/api/profile/")
        let headers = [ "Content-Type": "application/json" ]
        Alamofire.request(url, method: .post, parameters: params ,encoding: JSONEncoding.default, headers: headers).responseJSON{(response) in
            self.serverResponse = response
            print (response)
            switch response.result{
            case .success:
                if let json = response.result.value as! [String:Any]?{
                    if let idUser = json["userID"] as? String {
                    print( idUser)
                    }
                }
                self.showSuccessAlert()
                case .failure(let error):
                print (error)
            }
        }
        ProfileViewController.self.profileisupdated = true
    }
    
    func createProfile(){
        
        let params : [String:String] = ["userID" : "\(SignInViewController.UserId)"]
        let headers = [ "Content-Type": "application/json" ]
        let url = String(format: "http://localhost:8082/api/profile/")
        if SignInViewController.self.UserId == "" {
            showSignInAlert() }
        else {
                      Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
                       .responseJSON{(response) in
                          self.serverResponse = response
                         print (response)
                         switch response.result{
                         case .success:

                        if let json = response.result.value as! [String:Any]?{
                             if let id = json["id"] as? String {
                                self.idProfile = id
                                self.updateProfile()
                        
                             }
                            }
                         case .failure(let error):
                          print (error)
                        }
                  }
        }
        print (self.idProfile)
    }
    @IBAction func saveButtonTapped(_ sender: Any) {
        if self.idProfile == "" {
            print("hello11")
        }else{
            print("hello")
            updateProfile()
        }
            
        ProfileViewController.profileIsSet = true
        if  ProfileViewController.profileIsSet == false {
            showFailAlert()
        }

    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        countryTextField.resignFirstResponder()
    }
    //alerts
    func showSignInAlert() {
        let alert = UIAlertController(title: "Error", message: "Please sign in first", preferredStyle: .alert)
               alert.addAction(UIAlertAction.init(title: "Dismiss", style: .default) { (UIAlertAction) -> Void in
               })
               self.present(alert , animated: true)
    }
    
    func showSuccessAlert(){
    let alert = UIAlertController(title: "Adding profile successed", message: "Your profile is updated ", preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "Dismiss", style: .default) { (UIAlertAction) -> Void in
            self.navigationController?.popViewController(animated: true)
        })
        self.present(alert , animated: true)
    }
    func showFailAlert(){
    let alert = UIAlertController(title: "Adding profile failed", message: "Updating profile failed! ", preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "Dismiss", style: .default) { (UIAlertAction) -> Void in
        })
        self.present(alert , animated: true)
    }
    
    // selecting picture
    @IBAction func editPictureButtonTapped(_ sender: Any) {
    if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
        print("Button capture")
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
        }
    }
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!){
        if let image = editingInfo[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            userProfileImageView.image = image}
        self.dismiss(animated: true, completion: nil)
    }
}

extension ProfileViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}



