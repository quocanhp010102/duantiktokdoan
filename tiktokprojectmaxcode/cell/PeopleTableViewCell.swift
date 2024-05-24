//
//  PeopleTableViewCell.swift
//  tiktokprojectmaxcode
//
//  Created by quocanhppp on 10/05/2024.
//

import UIKit

class PeopleTableViewCell: UITableViewCell {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    var user:User?{
        didSet{
            loadData()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        avatar.layer.cornerRadius = 25
        
        // Configure the view for the selected state
    }
    func loadData(){
        self.usernameLabel.text = user?.username
        guard let profileImageUrl = user?.profileImageUrl else {return}
        avatar.loadImage(profileImageUrl)
    }

}
