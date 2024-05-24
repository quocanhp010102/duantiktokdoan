//
//  editProfileViewController.swift
//  tiktokprojectmaxcode
//
//  Created by quocanhppp on 16/05/2024.
//

import UIKit
import FirebaseAuth
import ProgressHUD
class editProfileViewController: UIViewController {

    @IBOutlet weak var deleteAccountBTN: UIButton!
    @IBOutlet weak var logOutBTN: UIButton!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var avatar: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func saveBTNDidtaped(_ sender: Any) {
        var dict = Dictionary<String,Any>()
        if let username = userNameTextField.text, !username.isEmpty {
            dict["username"] = username
        }
        Api.User.saveUserProfile(dict: dict) {
            ProgressHUD.succeed("success")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let profileVC = storyboard.instantiateViewController(identifier: "ProfileViewController") as! ProfileViewController
            self.navigationController?.pushViewController(profileVC, animated: true)
            
        } onError: { errorMessage in
            ProgressHUD.failed(errorMessage)
        }

    }
    func setUpView(){
        avatar.layer.cornerRadius = 50
        logOutBTN.layer.cornerRadius = 35/2
        avatar.contentMode = .scaleAspectFill
    }
    func observeData(){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Api.User.observerUser(withId: uid) { user in
            self.userNameTextField.text = user.username
            self.avatar.loadImage(user.profileImageUrl)
        }
    }
    @IBAction func logOutDidtaped(_ sender: Any) {
    }
    
    @IBAction func deleteAccountDidtap(_ sender: Any) {
        Api.User.deleteAccount()
    }
    

}
