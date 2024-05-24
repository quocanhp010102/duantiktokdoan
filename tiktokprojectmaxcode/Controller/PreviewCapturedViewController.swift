//
//  PreviewCapturedViewController.swift
//  tiktokprojectmaxcode
//
//  Created by quocanhppp on 29/04/2024.
//

import UIKit
import AVKit
class PreviewCapturedViewController: UIViewController {

    var currentlyPlayingvideoClip:videoClips
    let recordedClips:[videoClips]
    var viewWillDenitRestartVideoSession: (() -> Void)?
    var player:AVPlayer = AVPlayer()
    var playerLayer:AVPlayerLayer = AVPlayerLayer()
    var urlsForVids:[URL] = []{
        didSet{
            print("output url unwwrapped", urlsForVids)
        }
    }
    var hideStatusBar:Bool =  true {
        didSet{
           
            UIView.animate(withDuration: 0.3){ [weak self] in
                self?.setNeedsStatusBarAppearanceUpdate()
                
            }
        }
    }
    @IBOutlet weak var nextBTN: UIButton!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    deinit{
        print("previewCapturedVideoVC was deinited")
        (viewWillDenitRestartVideoSession)?()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        hideStatusBar = true
        handleStartPlayingFistClip()
        print("\(recordedClips.count)")
        recordedClips.forEach { clip in
            urlsForVids.append(clip.videoUrl)
        }
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        navigationController?.setNavigationBarHidden(true, animated: animated)
        player.play()
        hideStatusBar = true
    }
   
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
        navigationController?.setNavigationBarHidden(false, animated: animated)
        player.pause()
    }

    init?(coder: NSCoder, recordedClips:[videoClips]){
        self.currentlyPlayingvideoClip = recordedClips.first!
        self.recordedClips =  recordedClips
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func handleStartPlayingFistClip(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
            guard let fistClip = self.recordedClips.first else{return}
            self.currentlyPlayingvideoClip = fistClip
            self.setupPlayerView(with: fistClip)
        }
    }
    func setUpView(){
        nextBTN.layer.cornerRadius = 2
        nextBTN.backgroundColor = UIColor(red: 254/255, green: 44/255, blue: 88/255, alpha: 1.0)
    }
    func setupPlayerView(with videoClip: videoClips){
        let player = AVPlayer(url: videoClip.videoUrl)
        let playerLayer = AVPlayerLayer(player: player)
        self.player = player
        self.playerLayer = playerLayer
        playerLayer.frame = thumbnailImageView.frame
        self.player = player
        self.playerLayer = playerLayer
        thumbnailImageView.layer.insertSublayer(playerLayer, at: 3)
        player.play()
        NotificationCenter.default.addObserver(self, selector: #selector(avPlayerItemDidPlayToEndTime(notification:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
        handleMirrorPlayer(cameraPosition: videoClip.cameraPosition)
    }
    func removePeriodcTimeObserver(){
        player.replaceCurrentItem(with: nil)
        playerLayer.removeFromSuperlayer()
    }
    @objc func avPlayerItemDidPlayToEndTime(notification: Notification){
        if let currentIndex = recordedClips.firstIndex(of: currentlyPlayingvideoClip){
            let nextIndex = currentIndex + 1
            if nextIndex > recordedClips.count - 1 {
                removePeriodcTimeObserver()
                guard let fistClip = recordedClips.first else {return}
                setupPlayerView(with: fistClip)
                currentlyPlayingvideoClip = fistClip
            }else{
                for(index,clip) in recordedClips.enumerated(){
                    if index == nextIndex {
                        removePeriodcTimeObserver()
                        setupPlayerView(with: clip)
                        currentlyPlayingvideoClip = clip
                    }
                }
            }
        }
    }
    func handleMirrorPlayer(cameraPosition: AVCaptureDevice.Position){
        if cameraPosition == .front{
            thumbnailImageView.transform = CGAffineTransform(scaleX: -1, y: -1)
        }else{
            thumbnailImageView.transform = .identity
        }
    }
    func handleMergeClips(){
        VideoCompositionWriter().mergeMultipleVideo(urls: urlsForVids){ success, outPutURL in
            if success {
                guard let outPutURLUnwrapped = outPutURL else {return}
                print("ouuPutURLUnwrapped : ",outPutURLUnwrapped)
                
                DispatchQueue.main.async {
                    let player = AVPlayer(url: outPutURLUnwrapped)
                    let vc = AVPlayerViewController()
                    vc.player = player
                    
                    self.present(vc, animated: true){
                        vc.player?.play()
                    }
                }
            }
            
        }
    }
    @IBAction func nextBTNDidTaped(_ sender: Any) {
        handleMergeClips()
        hideStatusBar = false
        let shareVC = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(identifier: "SharePostViewController", creator:  { coder -> SharePostViewController? in
            SharePostViewController(coder: coder, videoURL: self.currentlyPlayingvideoClip.videoUrl)
        })
        shareVC.selectedPhoto = thumbnailImageView.image
        navigationController?.pushViewController(shareVC, animated: true)
        return
    }
    @IBAction func cancelBTNDidtaped(_ sender: Any) {
        hideStatusBar = true
        navigationController?.popViewController(animated: true)
    }
}
