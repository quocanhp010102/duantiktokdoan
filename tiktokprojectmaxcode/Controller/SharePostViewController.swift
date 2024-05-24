//
//  SharePostViewController.swift
//  tiktokprojectmaxcode
//
//  Created by quocanhppp on 06/05/2024.
//

import UIKit
import AVFoundation
import ProgressHUD
class SharePostViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var snowBTN: UIButton!
    @IBOutlet weak var tysterBTN: UIButton!
    @IBOutlet weak var iGBTN: UIButton!
    @IBOutlet weak var postBTN: UIButton!
    @IBOutlet weak var DraftsBTN: UIButton!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    let originalVideoUrl : URL
    var selectedPhoto:UIImage?
    let placehold = "please write to description"
    var encodeVideoUrl : URL?
    override func viewDidLoad() {
        super.viewDidLoad()
        snowBTN.setTitle("", for: .normal)
        tysterBTN.setTitle("", for: .normal)
        iGBTN.setTitle("", for: .normal)
        textViewDidChanged()
        setUpView()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyBoard)))
        if let thumbnailImage = self.thumbnailImageForFileUrl(originalVideoUrl){
            self.selectedPhoto = thumbnailImage.imageRotated(by: .pi/2)
            thumbnailImageView.image = thumbnailImage.imageRotated(by: .pi/2)
        }
        saveVideoTobeUploadedToServerToTempDirectory(sourceURL: originalVideoUrl){[weak self] (outputURL) in
            self?.encodeVideoUrl = outputURL
            print("encodeVideoUrl : ", outputURL)
        }
        // Do any additional setup after loading the view.
    }
    func thumbnailImageForFileUrl(_ fileUrl: URL) -> UIImage?{
        let asset = AVAsset(url: fileUrl)
        let imagegenerator = AVAssetImageGenerator(asset: asset)
        do{
            let thumbnailCGImage = try imagegenerator.copyCGImage(at: CMTimeMake(value: 7, timescale: 1), actualTime: nil)
            return UIImage(cgImage: thumbnailCGImage)
        }catch let err{
            print(err)
        }
        return nil
    }
    @objc func hideKeyBoard(){
        self.view.endEditing(true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
       
    }
   
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
        
    }
    init?(coder: NSCoder, videoURL: URL){
        self.originalVideoUrl = videoURL
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setUpView(){
        DraftsBTN.layer.borderColor = UIColor.lightGray.cgColor
        DraftsBTN.layer.borderWidth = 0.3
        
    }
    @IBAction func sharePostDidTaped(_ sender: Any) {
        self.sharePost {
            self.dismiss(animated: true){
                self.tabBarController?.selectedIndex = 0
            }
        } onError: { errorMessage in
            ProgressHUD.failed(errorMessage)
        }

    }
    func sharePost(onSuccess:@escaping() -> Void,onError:@escaping(_ errorMessage:String) -> Void){
        ProgressHUD.animate("Please wait...", .ballVerticalBounce)
        Api.Post.sharePost(encodedVideoURL: encodeVideoUrl, selectedPhoto: selectedPhoto, textView: textView) {
            ProgressHUD.dismiss()
            onSuccess()
        } onError: { errorMessage in
            onError(errorMessage)
        }

    }
    
}
extension SharePostViewController: UITextViewDelegate{
    func textViewDidChanged(){
        textView.delegate = self
        textView.text = placehold
        textView.textColor = .lightGray
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = ""
            textView.textColor = .black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = placehold
            textView.textColor = .lightGray
        }
    }
}
extension UIImage{
    func imageRotated(by radian: CGFloat) -> UIImage {
        let rotatedSize = CGRect(origin: .zero, size: size)
            .applying(CGAffineTransform(rotationAngle: radian))
            .integral.size
        UIGraphicsBeginImageContext(rotatedSize)
        if let context = UIGraphicsGetCurrentContext(){
            let origin = CGPoint(x: rotatedSize.width / 2.0, y: rotatedSize.height / 2.0)
            context.translateBy(x: origin.x, y: origin.y)
            context.rotate(by: radian)
            draw(in: CGRect(x: -origin.y, y: -origin.x, width: size.width, height: size.height))
            let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return rotatedImage ?? self
        }
        return self
    }
}
