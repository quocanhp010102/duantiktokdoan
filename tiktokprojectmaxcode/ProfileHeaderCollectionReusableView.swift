//
//  ProfileHeaderCollectionReusableView.swift
//  tiktokprojectmaxcode
//
//  Created by quocanhppp on 08/05/2024.
//

import UIKit

class ProfileHeaderCollectionReusableView: UICollectionReusableView {
    @IBOutlet weak var avatar: UIImageView!
    
    @IBOutlet weak var editProfileBTN: UIButton!
    @IBOutlet weak var favoriterBTN: UIButton!
    @IBOutlet weak var username: UILabel!
    
    var user:User?{
        didSet{
            updateView()
        }
    }
    func updateView(){
        self.username.text = "@" + user!.username!
        guard let profileImageUrl = user?.profileImageUrl else {return}
        self.avatar.loadImage(profileImageUrl)
    }
    func setupView(){
        avatar.layer.cornerRadius = 50
        editProfileBTN.layer.borderColor = UIColor.lightGray.cgColor
        editProfileBTN.layer.borderWidth = 0.8
        editProfileBTN.backgroundColor = .white
        editProfileBTN.layer.cornerRadius = 5
        favoriterBTN.layer.borderColor = UIColor.lightGray.cgColor
        favoriterBTN.layer.borderWidth = 0.8
        favoriterBTN.backgroundColor = .white
        favoriterBTN.layer.cornerRadius = 5
        favoriterBTN.setTitle("", for: .normal)
    }
}
