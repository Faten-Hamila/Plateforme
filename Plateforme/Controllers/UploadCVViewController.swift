//
//  UploadCVViewController.swift
//  Plateforme
//
//  Created by Faten's MacBook  on 06/10/2020.
//  Copyright © 2020 faten hamila. All rights reserved.
//



//this is done

import UIKit
import SwiftyJSON
import Alamofire
import MobileCoreServices

class UploadCVViewController: UIViewController{
    var delegate : UIDocumentPickerDelegate?
    @IBOutlet weak var cvImageView: UIImageView!
    @IBOutlet weak var competenceLabel: UILabel!
    let url = "http://localhost:8051/api/competence/cv"
    var imageData = Data()
    var list = [String]()
    var localfileURL : URL? = nil
    var listCompetences : [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        competenceLabel.text = "Competences are:"
        competenceLabel.isHidden = true
    }
    
    @IBAction func uploadCVTapped(_ sender: Any) {
        if SignInViewController.userSignedIn == true {
        let data = NSData(contentsOf: localfileURL!)
            print(data!)
        do{
            self.Doc(url: url, docData: try Data(contentsOf: localfileURL!), parameters: ["file": "file" as AnyObject], fileName: localfileURL!.lastPathComponent)
            
        }catch{
            print(error)
        }
    }
        else {
        let alert = UIAlertController(title: "Error", message: "Please sign in first!", preferredStyle: .alert)
                              alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { action in
                                      }))
                       self.present(alert , animated: true)
        }
    }
    @IBAction func selectCVTapped(_ sender: Any) {
        if SignInViewController.userSignedIn == true {
       let documentsPicker = UIDocumentPickerViewController(documentTypes: [String(kUTTypePDF)], in: .import)
                  documentsPicker.delegate = self
                  documentsPicker.allowsMultipleSelection = false
                  documentsPicker.modalPresentationStyle = .formSheet
                  self.present(documentsPicker, animated: true, completion: nil)
    
    }
    else {
    let alert = UIAlertController(title: "Error", message: "Please sign in first!", preferredStyle: .alert)
                          alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { action in
                                  }))
                   self.present(alert , animated: true)
    }
    }
    
    func Doc(url: String, docData: Data?, parameters: [String : Any], onCompletion: ((JSON?) -> Void)? = nil, onError: ((Error?) -> Void)? = nil, fileName: String){
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.33){
        
    }
        
     let headers: HTTPHeaders = [
         "Content-type": "multipart/form-data"
     ]
        print("Headers => \(headers)")
        
        print("Server Url => \(url)")
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
                if let data = docData{
                    multipartFormData.append(data, withName: "file", fileName: fileName, mimeType: "application/pdf")
                }
                
                for (key, value) in parameters {
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                 print("PARAMS => \(multipartFormData)")
                }
                
            }, to: url, method: .post, headers: headers) { (result) in
                switch result{
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                       
                       DispatchQueue.main.asyncAfter(deadline: .now() + 0.33){
                          
                       }
                       
                        print("Succesfully uploaded")
                        if let err = response.error{
                            onError?(err)
                            return
                        }
                        print(JSON(response.result.value as Any))
                        onCompletion?(JSON(response.result.value as Any))
                        //extracting competences goes here
                        
                        if let json = response.result.value as! [String:Any]?{
                            if let idCompetence = json["id"] as? String {
                            print(idCompetence)
                            }
                            if let listCompetence = json ["list"] as? [String]{
                                self.competenceLabel.isHidden = false
                                print (listCompetence)
                                for competence in listCompetence {
                                    self.competenceLabel.text = self.competenceLabel.text! + "\(competence) "
                                }
                            }
                            
                        }
                        self.showSuccessAlert()
                        
                    }
                case .failure(let error):
                    print("Error in upload: \(error.localizedDescription)")
                    onError?(error)
                    self.showFailAlert()
                }
            }
    }
     func showSuccessAlert(){
        let alert = UIAlertController(title: "Uploading CV", message: "CV uploaded successfully!", preferredStyle: .alert)
            alert.addAction(UIAlertAction.init(title: "Dismiss", style: .default) { (UIAlertAction) -> Void in
                self.navigationController?.popViewController(animated: true)
                self.navigationController?.popViewController(animated: true)

            })
            self.present(alert , animated: true)
        }
        
        func showFailAlert(){
            
            let alert = UIAlertController(title: "Uploading CV", message: "something wrong happened! try again.", preferredStyle: .alert)
                       alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { action in
                               }))
                self.present(alert , animated: true)
    }
}

extension UploadCVViewController : UIDocumentMenuDelegate, UIDocumentPickerDelegate,UINavigationControllerDelegate{
   
    
    func documentMenu(_ documentMenu: UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
               present(documentPicker, animated: true, completion: nil)
    }
    
    
public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
    guard let myURL = urls.first else {
        return
    }
    localfileURL = myURL
    print("import result : \(myURL)")
    
}

func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
    print("view was cancelled")
    dismiss(animated: true, completion: nil)
}
}
