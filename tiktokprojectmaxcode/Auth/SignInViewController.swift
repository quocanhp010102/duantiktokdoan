//
//  SignInViewController.swift
//  tiktokprojectmaxcode
//
//  Created by quocanhppp on 12/04/2024.
//

import UIKit
import ProgressHUD
class SignInViewController: UIViewController {

    @IBOutlet weak var signInBTN: UIButton!
    @IBOutlet weak var usernameView: UIView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var passwordTextFiled: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUsernameTextfiled()
        setupPasswordTextfiled()
        // Do any additional setup after loading the view.
    }
    

    @IBAction func signInDidTapped(_ sender: Any) {
        self.view.endEditing(true)
        self.validateFields()
        self.signIn {
            let scene = UIApplication.shared.connectedScenes.first
            if let sd:SceneDelegate = (scene?.delegate as? SceneDelegate){
                sd.configInitiaViewController()
            }
           
        } onError: { errorMessage in
            ProgressHUD.failed(errorMessage)
        }

    }
    
}
extension SignInViewController {
    func signIn(onSuccess:@escaping() -> Void,onError:@escaping(_ errorMessage:String) -> Void){
        ProgressHUD.progress(1)
        Api.User.signIn(email: self.usernameTextField.text!, password: self.passwordTextFiled.text!) {
            ProgressHUD.dismiss()
            onSuccess()
        } onError: { errorMessage in
            onError(errorMessage)
        }

    }
    func setupUsernameTextfiled (){
        usernameView.layer.borderWidth = 1
        usernameView.layer.borderColor = CGColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 0.8)
        usernameView.layer.cornerRadius = 20
        usernameView.clipsToBounds = true
        usernameTextField.borderStyle = .none
        signInBTN.layer.cornerRadius = 18
    }
    @IBAction func signInAction(_ sender: Any) {
        
    }
    func setupPasswordTextfiled (){
        passwordView.layer.borderWidth = 1
        passwordView.layer.borderColor = CGColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 0.8)
        passwordView.layer.cornerRadius = 20
        passwordView.clipsToBounds = true
        passwordTextFiled.borderStyle = .none
    }
    func validateFields(){
        guard let username = self.usernameTextField.text, !username.isEmpty else {
            print("input username")
            ProgressHUD.failed("input username")
            return
        }
       
        guard let password = self.passwordTextFiled.text, !password.isEmpty else {
            print("input password")
            ProgressHUD.failed("input password")
            return
        }
    }
}
