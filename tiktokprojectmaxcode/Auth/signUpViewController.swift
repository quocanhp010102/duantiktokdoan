//
//  signUpViewController.swift
//  tiktokprojectmaxcode
//
//  Created by quocanhppp on 10/04/2024.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import PhotosUI
import FirebaseStorage
import ProgressHUD
class signUpViewController: UIViewController {

    var image:UIImage? = nil
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var usernameTextfield: UITextField!
    @IBOutlet weak var usernameView: UIView!
    @IBOutlet weak var signUpBTN: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupUsernameTextfiled()
        setupPasswordTextfiled()
        setupEmailTextfiled()
        setupViewImage()
        // Do any additional setup after loading the view.
    }
    
    func validateFields(){
        guard let username = self.usernameTextfield.text, !username.isEmpty else {
            print("input username")
            ProgressHUD.failed("input username")
            return
        }
        guard let email = self.emailTextfield.text, !email.isEmpty else {
            print("input email")
            ProgressHUD.failed("input email")
            return
        }
        guard let password = self.passwordTextfield.text, !password.isEmpty else {
            print("input password")
            ProgressHUD.failed("input password")
            return
        }
    }
    @IBAction func signUpdiptap(_ sender: Any) {
        self.signUp {
            let scene = UIApplication.shared.connectedScenes.first
            if let sd:SceneDelegate = (scene?.delegate as? SceneDelegate){
                sd.configInitiaViewController()
            }
        } onError: { errorMessage in
            ProgressHUD.failed(errorMessage)
        }

        self.validateFields()
        
        
    }
    func setupNavigationBar (){
        navigationItem.title = "Create new account"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    func setupUsernameTextfiled (){
        usernameView.layer.borderWidth = 1
        usernameView.layer.borderColor = CGColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 0.8)
        usernameView.layer.cornerRadius = 20
        usernameView.clipsToBounds = true
        usernameTextfield.borderStyle = .none
    }
    func setupPasswordTextfiled (){
        passwordView.layer.borderWidth = 1
        passwordView.layer.borderColor = CGColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 0.8)
        passwordView.layer.cornerRadius = 20
        passwordView.clipsToBounds = true
        passwordTextfield.borderStyle = .none
    }
    func setupEmailTextfiled (){
        emailView.layer.borderWidth = 1
        emailView.layer.borderColor = CGColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 0.8)
        emailView.layer.cornerRadius = 20
        emailView.clipsToBounds = true
        emailTextfield.borderStyle = .none
    }
    func setupViewImage(){
        avatar.layer.cornerRadius =  60
        signUpBTN.layer.cornerRadius = 18
        avatar.clipsToBounds = true
        avatar.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(presentPicker))
        avatar.addGestureRecognizer(tapGesture)
    }
   
}
extension signUpViewController:PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        for item in results {
            item.itemProvider.loadObject(ofClass: UIImage.self){image , error in
                if let imageSelected = image as? UIImage{
                    //print(imageSelected)
                    
                    DispatchQueue.main.async {
                        self.avatar.image = imageSelected
                        self.image = imageSelected
                    }
                }
            }
        }
        dismiss(animated: true)
    }
    @objc func presentPicker(){
        var configuration:PHPickerConfiguration = PHPickerConfiguration()
        configuration.filter = PHPickerFilter.images
        configuration.selectionLimit = 1
        let picker : PHPickerViewController = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        self.present(picker, animated: true)
    }
    
}
extension signUpViewController {
    func signUp(onSuccess:@escaping() -> Void,onError:@escaping(_ errorMessage:String) -> Void){
        ProgressHUD.progress(1)
        Api.User.signUp(withUsername: self.usernameTextfield.text!, email: self.emailTextfield.text!, password: self.passwordTextfield.text!, image: self.image){
            ProgressHUD.dismiss()
               onSuccess()
        } onError: { errorMessage in
            onError(errorMessage)
        }
    }
}
