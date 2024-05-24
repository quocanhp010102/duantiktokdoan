//
//  HomeCollectionViewCell.swift
//  tiktokprojectmaxcode
//
//  Created by quocanhppp on 07/05/2024.
//

import UIKit
import AVFoundation
protocol HomeCollectionViewCellDelegate{
    func goToProfileUserVC(userId:String)
}
class HomeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var postVideo: UIImageView!
    @IBOutlet weak var descriptionv: UILabel!
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var shareBTN: UIButton!
    @IBOutlet weak var yeuBTN: UIButton!
    @IBOutlet weak var commentBTN: UIButton!
    @IBOutlet weak var likeBTN: UIButton!
    @IBOutlet weak var avatar: UIImageView!
    var isplaying = false
    var queuePlayer:AVQueuePlayer?
    var playerLayer:AVPlayerLayer?
    var playbackloop:AVPlayerLooper?
    var delegate:HomeCollectionViewCellDelegate?
    var post:post?{
        didSet{
            updateView()
        }
    }
    var user:User?{
        didSet{
            setupUserInfo()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        shareBTN.setTitle("", for: .normal)
        yeuBTN.setTitle("", for: .normal)
        commentBTN.setTitle("", for: .normal)
        likeBTN.setTitle("", for: .normal)
        avatar.layer.cornerRadius = 55/2
        let tapGestureForAvatar = UITapGestureRecognizer(target: self, action: #selector(avatar_TouchUpInside))
        avatar.isUserInteractionEnabled = true
        avatar.addGestureRecognizer(tapGestureForAvatar)
        avatar.clipsToBounds = true
    }
    @objc func avatar_TouchUpInside(){
        if let id = user?.uid{
            delegate?.goToProfileUserVC(userId: id)
        }
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        playerLayer?.removeFromSuperlayer()
        queuePlayer?.pause()
    }
    func updateView(){
        descriptionv.text = post?.description
        if let videoUrlString = post?.videoUrl , let videoUrl = URL(string: videoUrlString){
            let playerItem = AVPlayerItem(url: videoUrl)
            self.queuePlayer = AVQueuePlayer(playerItem: playerItem)
            self.playerLayer = AVPlayerLayer(player: self.queuePlayer)
            
            guard let playerLayer = self.playerLayer else {return}
            guard let queuePlayer = self.queuePlayer else {return}
            self.playbackloop = AVPlayerLooper.init(player: queuePlayer, templateItem: playerItem)
            
            playerLayer.videoGravity = .resizeAspectFill
            playerLayer.frame = contentView.bounds
            postVideo.layer.insertSublayer(playerLayer, at: 3)
            queuePlayer.play()
        }
    }
    func setupUserInfo(){
        userNameLabel.text = user?.username
        guard let profileImageUrl = user?.profileImageUrl else {return}
        avatar.loadImage(profileImageUrl)
    }
    func replay(){
        if !isplaying{
            self.queuePlayer?.seek(to: .zero)
            self.queuePlayer?.play()
            
            play()
        }
    }
    func play(){
        if !isplaying {
            self.queuePlayer?.play()
            isplaying = true
        }
    }
    func pause(){
        if isplaying {
            self.queuePlayer?.pause()
            isplaying = false
        }
    }
    func stop(){
        queuePlayer?.pause()
        queuePlayer?.seek(to: CMTime.init(seconds: 0, preferredTimescale: 1))
    }
}
