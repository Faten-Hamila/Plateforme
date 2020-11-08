//
//  ViewController.swift
//  Plateforme
//
//  Created by Faten's MacBook  on 20/09/2020.
//  Copyright © 2020 faten hamila. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
   
static var nameToDisplay = ""
    
    @IBOutlet weak var signinbutton: UIButton!
    
    @IBOutlet weak var signupButton: UIButton!
    let signincontroller = SignInViewController()
    let signupController = SignUpViewController()
    let profileController = ProfileViewController()
    let takethetestController = LevelTestViewController()
    let somethingController = UploadCVViewController()
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet var homeCollectionView : UICollectionView!
    let imageArray = [UIImage(named: "im1"),
    UIImage(named: "im2"),
    UIImage(named: "im3"),
    UIImage(named: "im4")]
    let descriptionArray = ["Description1","Description2","Description3","Description4"]
    var user: User?
      

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        if (SignInViewController.userSignedIn == false){
            usernameLabel.isHidden = true
        }
        if (SignInViewController.userSignedIn == true){
            usernameLabel.text = SignInViewController.Username
        }
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 180, height: 180)
        homeCollectionView.collectionViewLayout = layout
        homeCollectionView.register(MyCollectionViewCell.nib() , forCellWithReuseIdentifier: MyCollectionViewCell.identifier)
        homeCollectionView.delegate = self
        homeCollectionView.dataSource = self

    }
}
extension HomeViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath ){
        collectionView.deselectItem(at: indexPath, animated: true)
        print ("you tapped me")

    }
}

extension HomeViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyCollectionViewCell.identifier, for: indexPath) as! MyCollectionViewCell
        let cellIndex = indexPath.item
        cell.configure(with: imageArray[cellIndex]!, description: descriptionArray[cellIndex])
        cell.contentView.layer.cornerRadius = 10
               cell.contentView.layer.borderColor = UIColor.purple.cgColor
               cell.contentView.layer.borderWidth = 1.0
               cell.layer.shadowColor = UIColor.gray.cgColor
               cell.layer.shadowOffset = CGSize (width: 0.0, height: 2.0)
               cell.layer.shadowRadius = 2.0
               cell.layer.shadowOpacity = 0.5
               cell.layer.masksToBounds = false
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let heightVal = self.view.frame.height/4
        let widthVal = self.view.frame.width/2
        return CGSize(width: widthVal-10, height: heightVal-10)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
extension HomeViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
    }
}



