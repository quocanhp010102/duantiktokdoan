//
//  ViewController.swift
//  tiktokprojectmaxcode
//
//  Created by quocanhppp on 09/04/2024.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var signinwithemailBTN: UIButton!
    @IBOutlet weak var signinwithGGBTN: UIButton!
    @IBOutlet weak var signupFBBTN: UIButton!
    @IBOutlet weak var signUpBTN: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    func setupView(){
        signinwithemailBTN.layer.cornerRadius = 18
        signinwithGGBTN.layer.cornerRadius = 18
        signupFBBTN.layer.cornerRadius = 18
        signUpBTN.layer.cornerRadius = 18
    }
    @IBAction func signUpDidTapped(_ sender: Any) {
        let stoadyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = stoadyboard.instantiateViewController(withIdentifier: "signUpViewController") as! signUpViewController
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    @IBAction func signInDidTapped(_ sender: Any) {
        let stoadyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = stoadyboard.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

