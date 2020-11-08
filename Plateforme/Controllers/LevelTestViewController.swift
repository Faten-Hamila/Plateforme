//
//  LevelTestViewController.swift
//  Plateforme
//
//  Created by Faten's MacBook  on 04/10/2020.
//  Copyright © 2020 faten hamila. All rights reserved.
//
// 
import UIKit
import Alamofire
import SwiftyJSON


class LevelTestViewController: UIViewController{

//struct TestQuestion {
//    var difficulty : String
//    var questionId : String
//    var questionNbr : Int
//    var questionContent : String
//    var answers : [Answer]
//
//    init (difficulty : String ,questionId : String ,questionNbr : Int,questionContent : String,answers : [Answer]){
//        self.difficulty = difficulty
//        self.questionId = questionId
//        self.questionNbr = questionNbr
//        self.questionContent = questionContent
//        self.answers = answers
//    }
//   }
//
//struct Test {
//       var id :  String
//       var numTest : Int
//       var questionList :[TestQuestion]
//       var userId : String
//       var result :Int
//
//    init(id :  String ,numTest : Int, questionList :[TestQuestion], userId : String,result :Int) {
//        self.id = id
//        self.numTest = numTest
//        self.questionList = questionList
//        self.userId = userId
//        self.result = result
//    }
//   }
//
//struct Answer {
//       var answer_id: Int
//       var answerContent: String
//       var checked: Bool
//       var correct: Bool
//
//    init(answer_id: Int , answerContent: String , checked: Bool, correct: Bool){
//        self.answer_id = answer_id
//        self.answerContent = answerContent
//        self.checked = checked
//        self.correct = correct
//    }
//   }
    
    @IBOutlet weak var generatetestButton: UIButton!
    @IBOutlet weak var testQuestionTableView: UITableView!
    var questionarray = [String]()
    @IBOutlet weak var resultLabel: UILabel!
    var answerArray = [String]()
    var selectedIndexes = [[IndexPath]]()
    var testId = ""
    var JSON : [String:Any] = [:]

    var serverResponse : DataResponse<Any>? = nil
    var testIsGenerated = false
    var answersSubmitted = false
    override func viewDidLoad() {
        resultLabel.isHidden = true
        testQuestionTableView.isHidden = true
        testQuestionTableView.delegate = self
        testQuestionTableView.dataSource = self
        let header = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 50))
        let titleLabel = UILabel (frame: header.bounds)
        titleLabel.text = "This is an evaluation test"
        titleLabel.font = .boldSystemFont(ofSize: 20.0)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        header.addSubview(titleLabel)
        testQuestionTableView.tableHeaderView = header

    }
    func getTest (){
        let url = String(format: "http://localhost:8060/api/testNiveau/create")
        let headers = [ "Content-Type": "application/json" ]
        Alamofire.request(url, method: .get, headers: headers).responseJSON{(response) in
            self.serverResponse = response
            //print (response)
            switch response.result{
                case .success:
                print ("woooohoooooo!")
                if let json = response.result.value as! [String:Any]?{
                    self.JSON = json

                   if let idTest = json["idTest"] as? String {
                    self.testId = idTest
                        print(idTest)
                    }
                    if let numTest = json["numTest"] as? Int {
                        print(numTest)
                    }
                    if let questionList = json["questionList"] as? [[String:Any]] {
                        for question in questionList {
                            if let answersList = question["answers"] as? [[String : Any]]{
                                for answer in answersList {
                                    let answerContent = answer["answerContent"]
                                   self.answerArray.append(answerContent as! String)
                                  //  print (answerContent!)
                                    let answerId = answer [ "answer_id"]
                                    print (answerId!)
                                    let checked = answer["checked"]
                                    print (checked!)
                                    let correct = answer["correct"]
                                    print (correct!)
                                }
                            }
                            let questionContent = question["questionContent"]
                            self.questionarray.append(questionContent as! String)
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
                    self.testQuestionTableView.isHidden = false
                    self.testQuestionTableView.reloadData()
                }
                case .failure(let error):
                    print (error)
            }
            }
        }
    func sendAnswers(){
        
        let url = String(format: "http://localhost:8060/api/testNiveau/\(self.testId)")
        let headers = [ "Content-Type": "application/json" ]
        Alamofire.request(url, method: .put, parameters: self.JSON, encoding: JSONEncoding.default, headers: headers).responseJSON{(response) in
            self.serverResponse = response
            //print (response)
            switch response.result{
                case .success:
                if let json = response.result.value as! [String:Any]?{

                   if let idTest = json["idTest"] as? String {
                        print(idTest)
                    }
                    if let numTest = json["numTest"] as? Int {
                        print(numTest)
                    }
                    if let questionList = json["questionList"] as? [[String:Any]] {
                        for question in questionList {
                            if let answersList = question["answers"] as? [[String : Any]]{
                                for answer in answersList {
                                    let answerContent = answer["answerContent"]
                                   self.answerArray.append(answerContent as! String)
                                  //  print (answerContent!)
                                    let answerId = answer [ "answer_id"]
                                    print (answerId!)
                                    let checked = answer["checked"]
                                    print (checked!)
                                    let correct = answer["correct"]
                                    print (correct!)
                                }
                            }
                            let questionContent = question["questionContent"]
                            self.questionarray.append(questionContent as! String)
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
                    self.testQuestionTableView.isHidden = false
                    self.testQuestionTableView.reloadData()
                }
                case .failure(let error):
                    print (error)
            }
            }
        }
        

    func getResult(){
        resultLabel.isHidden = false
        //resultLabel.text = "Your score is : \(result)"
    }

    @IBAction func gereratetestButtonTapped(_ sender: Any) {
        if SignInViewController.userSignedIn == true{
            getTest()
            showSuccessAlertGeneratingTest()
            generatetestButton.isHidden = true
        }
            else {
               showFailAlertGeneratingTest()
            }
        testIsGenerated = true
        reloadInputViews()
    }

    @IBAction func submitanswersButtonTapped(_ sender: Any) {
        if (testIsGenerated == true)  {
        }
        else {
            
        }
    }
    
    func showSuccessAlertGeneratingTest(){
        let alert = UIAlertController(title: "Generating test", message: "Test generated successfully!", preferredStyle: .alert)
            alert.addAction(UIAlertAction.init(title: "Dismiss", style: .default) { (UIAlertAction) -> Void in
                self.navigationController?.popViewController(animated: true)
                self.navigationController?.popViewController(animated: true)
                })
            self.present(alert , animated: true)
        }

    func showFailAlertGeneratingTest(){
            let alert = UIAlertController(title: "Generating test", message: "Please sign in first", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { action in
                }))
                self.present(alert , animated: true)
    }
     func showSuccessAlertSubmittingAnswers(){
            let alert = UIAlertController(title: "Submitting answers", message: "answers submitted successfully !", preferredStyle: .alert)
                alert.addAction(UIAlertAction.init(title: "Dismiss", style: .default) { (UIAlertAction) -> Void in
                    self.navigationController?.popViewController(animated: true)
                    self.navigationController?.popViewController(animated: true)
                    })
                self.present(alert , animated: true)
            }

        func showFailAlertSubmittingAnswers(){
                let alert = UIAlertController(title: "Submitting answers", message: "Please generate a test first !", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { action in
                    }))
                    self.present(alert , animated: true)
    }
}






extension LevelTestViewController : UITableViewDataSource, UITableViewDelegate{
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
    }
    //or height for footer
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
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
        tableView.allowsMultipleSelection = false
        if (tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCell.AccessoryType.checkmark) {
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.none
        }
        else {
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.checkmark
            if let questionList = self.JSON["questionList"] as? [[String:Any]] {
                for question in questionList {
                    if let answersList = question["answers"] as? [[String : Any]]{
                        for answer in answersList {
                            let answerContent = answer["answerContent"]
                           self.answerArray.append(answerContent as! String)
                          //  print (answerContent!)
                            let answerId = answer [ "answer_id"]
                            print (answerId!)
                            let checked = answer["checked"]
                            print (checked!)
                            let correct = answer["correct"]
                            print (correct!)
                        }
                    }
                    
            }
            }

        }
    }
    
//    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
//        if let selectedIndexPathsInSection = tableView.indexPathsForSelectedRows?.filter({ $0.section == indexPath.section }), !selectedIndexPathsInSection.isEmpty {
//            selectedIndexPathsInSection.forEach({ tableView.deselectRow(at: $0, animated: false) })
//        }
//        return indexPath
//    }


}
    

