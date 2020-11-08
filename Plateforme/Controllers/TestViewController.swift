//
//  TestViewController.swift
//  Plateforme
//
//  Created by Faten's MacBook  on 24/09/2020.
//  Copyright © 2020 faten hamila. All rights reserved.
//

// check
import UIKit
import Alamofire
import SwiftyJSON


class TestViewController: UIViewController {
    
    struct TestQuestion {
    var questionId : String
    var questionNbr : Int
    var questionContent : String
    var answers : [Answer]
   
    }
    struct Test {
        var id :  String
        var numTest : Int
        var questionList :[TestQuestion]
        var userId : String
        var result :Int
    }
    struct Answer {
        var answer_id: Int
        var answerContent: String
        var checked: Bool
        var correct: Bool
    
    }

    @IBOutlet weak var testQuestionTableView: UITableView!
    var questionarray = [String]()
       var answerArray = [String]()
       var selectedIndexes = [[IndexPath]]()

    @IBOutlet weak var resultLabel: UILabel!
    var serverResponse : DataResponse<Any>? = nil
       var testIsGenerated = false
       override func viewDidLoad() {
           
           testQuestionTableView.delegate = self
           testQuestionTableView.dataSource = self
           let header = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 50))
           let titleLabel = UILabel (frame: header.bounds)
           titleLabel.text = "This is a learning style test"
           titleLabel.font = .boldSystemFont(ofSize: 20.0)
           titleLabel.textAlignment = .center
           titleLabel.numberOfLines = 0
           header.addSubview(titleLabel)
           testQuestionTableView.tableHeaderView = header
           super.viewDidLoad()
           
       }

       func getTest (){
           let url = String(format: "http://localhost:8061/api/testProfile/question")
           let headers = [ "Content-Type": "application/json" ]
           Alamofire.request(url, method: .get, headers: headers).responseJSON{(response) in
               self.serverResponse = response
               //print (response)
               switch response.result{
                   case .success:
                   print ("woooohoooooo!")
                   if let json = response.result.value as! [String:Any]?{

                      if let idTest = json["idTest"] as? String {
                           print(idTest)
                       }
                       if let numTest = json["numTest"] as? Int {
                           print(numTest)
                       }
                       if let questionList = json["questionList"] as? [[String:Any]] {
                         //  print(questionList)
                           for question in questionList {
                               if let answersList = question["answers"] as? [[String : Any]]{
                                   
                                  // self.testQuestionsArray.questionList
                                 //  self.arrayAnswers.append(answersList)
                                   //print (self.arrayAnswers)
                                   for answer in answersList {
                                       let answerContent = answer["answerContent"]
                                      self.answerArray.append(answerContent as! String)
                                     //  print (answerContent!)
                                       let answerId = answer [ "answer_id"]
                                       let checked = answer["checked"]
                                       let correct = answer["correct"]
                                   }
                               }
                               let questionContent = question["questionContent"]
                               self.questionarray.append(questionContent as! String)
                               //this is done
                               //print ("this is question content \(questionContent!)")
                       }
                           print("ANSWER CONTENT\(self.answerArray)")
                           print ("question CONTENT\(self.questionarray)")
                       }

                       if let userId = json["userId"] as? String {
                           print(userId)
                       }
                       if let result = json["result"] as? Int {
                           print(result)
                       }
                       self.testQuestionTableView.reloadData()
                   }
                   case .failure(let error):
                       print (error)
               }
               }
           }

       func getResult(){
       
       }

       @IBAction func gereratetestButtonTapped(_ sender: Any) {
           if SignInViewController.userSignedIn == true{
               getTest()
               showSuccessAlert()
           }
               else {
                  showFailAlert()
               }
           testIsGenerated = true
           reloadInputViews()
       }

       @IBAction func submitanswersButtonTapped(_ sender: Any) {
           if testIsGenerated == true {
               getResult()
           }

       }
       func showSuccessAlert(){
           let alert = UIAlertController(title: "Generating test", message: "Test generated successfully!", preferredStyle: .alert)
               alert.addAction(UIAlertAction.init(title: "Dismiss", style: .default) { (UIAlertAction) -> Void in
                   self.navigationController?.popViewController(animated: true)
                   self.navigationController?.popViewController(animated: true)
                   })
               self.present(alert , animated: true)
           }

       func showFailAlert(){
               let alert = UIAlertController(title: "Generating test", message: "Please sign in first", preferredStyle: .alert)
               alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { action in
                   }))
                   self.present(alert , animated: true)
       }
   }
   extension TestViewController : UITableViewDataSource, UITableViewDelegate{
       

       func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return 40.0
       }
       func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
           return 20.0
       }
       
       func numberOfSections(in tableView: UITableView) -> Int {
           return questionarray.count
       }
          
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return 4
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let questionCell = tableView.dequeueReusableCell(withIdentifier: "questionCell", for: indexPath)
           questionCell.textLabel?.text = answerArray[indexPath.section]
           return questionCell
       }

       func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
           return questionarray[section]
       }
       
       func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        if testQuestionTableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCell.AccessoryType.checkmark{
           tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.none
       }else
        {tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.checkmark
            }
    }
       
//       func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
//           if let selectedIndexPathsInSection = tableView.indexPathsForSelectedRows?.filter({ $0.section == indexPath.section }), !selectedIndexPathsInSection.isEmpty {
//               selectedIndexPathsInSection.forEach({ tableView.deselectRow(at: $0, animated: false) })
//           }
//           return indexPath
//       }
   }
       

    


