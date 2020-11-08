//
//  ContactViewController.swift
//  Plateforme
//
//  Created by Faten's MacBook  on 20/10/2020.
//  Copyright © 2020 faten hamila. All rights reserved.
//

//waiting for service to be done  coz it contains different data
import UIKit
import Alamofire
import SwiftyJSON
class ContactViewController: UIViewController {

    var serverResponse : DataResponse<Any>? = nil

    @IBOutlet weak var name: UITextField!
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var message: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func sendButtonTapped(_ sender: Any) {
        let name = self.name.text!
         let email = self.email.text!
         let message = self.message.text!
         
         let params : [String : String] = ["name":name, "email":email, "message":message]
         
        let url = String(format: "http://localhost:8083/api/Contact/")
         let headers = [ "Content-Type": "application/json" ]
         
         Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
          .responseJSON{(response) in
             self.serverResponse = response
            print (response)
            switch response.result{
            case .success:
             if let json = response.result.value as! [String: Any]? {
                 print ((json))
                self.showSuccessAlert()
             }
            case .failure:
                self.showFailAlert()
            }
    }
}
    func showSuccessAlert(){
    let alert = UIAlertController(title: "Contact us", message: "Message sent successfully.", preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "Dismiss", style: .default) { (UIAlertAction) -> Void in
            self.navigationController?.popViewController(animated: true)

        })
        self.present(alert , animated: true)
    }
     func showFailAlert(){
            
            let alert = UIAlertController(title: "Contact us", message: " Error! Please try again.", preferredStyle: .alert)
                       alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { action in
                               }))
                self.present(alert , animated: true)
    }
}
