//
//  PostProfileCollectionViewCell.swift
//  tiktokprojectmaxcode
//
//  Created by quocanhppp on 08/05/2024.
//

import UIKit
protocol PostProfileCollectionViewCellDelegate{
    func goToDetailVC(postId:String)
        
    
}
class PostProfileCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var postImage: UIImageView!
    var delegate:PostProfileCollectionViewCellDelegate?
    var postt:post?{
        didSet{
            updateView()
        }
    }
    func updateView(){
        guard let postTumbnailImageUrl = postt!.imageUrl else {return}
        self.postImage.loadImage(postTumbnailImageUrl)
        
        let tapGestureForPhoto = UITapGestureRecognizer(target: self, action: #selector(self.post_TouchUpInside))
        postImage.addGestureRecognizer(tapGestureForPhoto)
        postImage.isUserInteractionEnabled = true
    }
    @objc func post_TouchUpInside(){
        if let id = postt?.postId{
            delegate?.goToDetailVC(postId: id)
        }
    }
}
