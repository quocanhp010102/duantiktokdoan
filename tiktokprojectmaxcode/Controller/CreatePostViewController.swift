//
//  CreatePostViewController.swift
//  tiktokprojectmaxcode
//
//  Created by quocanhppp on 22/04/2024.
//

import UIKit
import AVFoundation
class CreatePostViewController: UIViewController {

    @IBOutlet weak var captureButtonView: UIView!
    @IBOutlet weak var captureButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var discadBTN: UIButton!
    @IBOutlet weak var savedBTN: UIButton!
    @IBOutlet weak var souldlabel: UILabel!
    @IBOutlet weak var souldimage: UIImageView!
    @IBOutlet weak var souldview: UIView!
    @IBOutlet weak var timesslabel: UILabel!
    @IBOutlet weak var flashlabel: UILabel!
    @IBOutlet weak var flashbtn: UIButton!
    @IBOutlet weak var timerlabel: UILabel!
    @IBOutlet weak var timerbtn: UIButton!
    @IBOutlet weak var filterlabel: UILabel!
    @IBOutlet weak var filterbtn: UIButton!
    @IBOutlet weak var beautylabel: UILabel!
    @IBOutlet weak var beautybtn: UIButton!
    @IBOutlet weak var speedlabel: UILabel!
    @IBOutlet weak var speedbtn: UIButton!
    @IBOutlet weak var fliplabel: UILabel!
    @IBOutlet weak var flipbtn: UIButton!
    @IBOutlet weak var timerCounterLabel: UILabel!
    let photoFileOutput = AVCapturePhotoOutput()
    let capturesession = AVCaptureSession()
    let moviFileOutput = AVCaptureMovieFileOutput()
    var actionInput:AVCaptureDeviceInput!
    var outputURL : URL!
    var currentCameraDevice:AVCaptureDevice!
    var thumbnailImage : UIImage?
    var recordedClips = [videoClips]()
    var isRecording = false
    var videoDurationOfLastClip = 0
    var recordingTimer : Timer?
    var currentMaxRecordingDuration:Int = 15 {
        didSet{
            timerCounterLabel.text = "\(currentMaxRecordingDuration) s"
        }
    }
    var total_recordTime_In_Secs = 0
    var total_recordTime_In_Minutes = 0
    
    lazy var segmentedProgressView = SegmentedProgressView(width: view.frame.width - 17.5)
    override func viewDidLoad() {
        super.viewDidLoad()
        if setupCaptureSession() {
            DispatchQueue.global(qos: .background).async {
                self.capturesession.startRunning()
            }
        }
        setUpView()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
   
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    func setUpView(){
        captureButton.setTitle("", for: .normal)
        cancelButton.setTitle("", for: .normal)
        flipbtn.setTitle("", for: .normal)
        speedbtn.setTitle("", for: .normal)
        beautybtn.setTitle("", for: .normal)
        filterbtn.setTitle("", for: .normal)
        timerbtn.setTitle("", for: .normal)
        flashbtn.setTitle("", for: .normal)
        savedBTN.setTitle("", for: .normal)
        discadBTN.setTitle("", for: .normal)
        captureButton.backgroundColor = UIColor(red: 254/255, green: 44/255, blue: 85/255, alpha: 1.0)
        captureButton.layer.cornerRadius = 68/2
        captureButtonView.layer.borderColor = UIColor(red: 254/255, green: 44/255, blue: 85/255, alpha: 1.0).cgColor
        captureButtonView.layer.borderWidth = 6
        captureButtonView.layer.cornerRadius = 85/2
        
        captureButton.layer.zPosition = 1
        captureButtonView.layer.zPosition = 1
        cancelButton.layer.zPosition = 1
        flipbtn.layer.zPosition = 1
        fliplabel.layer.zPosition = 1
        speedbtn.layer.zPosition = 1
        speedlabel.layer.zPosition = 1
        beautybtn.layer.zPosition = 1
        beautylabel.layer.zPosition = 1
        filterbtn.layer.zPosition = 1
        filterlabel.layer.zPosition = 1
        timerbtn.layer.zPosition = 1
        timerlabel.layer.zPosition = 1
        flashbtn.layer.zPosition = 1
        flashlabel.layer.zPosition = 1
        timesslabel.layer.zPosition = 1
        souldview.layer.zPosition = 1
        souldimage.layer.zPosition = 1
        souldlabel.layer.zPosition = 1
        savedBTN.layer.zPosition = 1
        discadBTN.layer.zPosition = 1
       
        view.addSubview(segmentedProgressView)
        segmentedProgressView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        segmentedProgressView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        segmentedProgressView.widthAnchor.constraint(equalToConstant:view.frame.width - 17.5).isActive = true
        segmentedProgressView.heightAnchor.constraint(equalToConstant: 6).isActive = true
        segmentedProgressView.translatesAutoresizingMaskIntoConstraints = false
    }

    @IBAction func saveBTNDidTapped(_ sender: Any) {
        let previewVC = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(identifier: "PreviewCapturedViewController", creator: {
            coder -> PreviewCapturedViewController? in
            PreviewCapturedViewController(coder: coder, recordedClips: self.recordedClips)
        })
        previewVC.viewWillDenitRestartVideoSession = {[weak self] in
            guard let self = self else {return}
            if self.setupCaptureSession(){
                DispatchQueue.global(qos: .background).async {
                    self.capturesession.startRunning()
                }
            }
        }
        navigationController?.pushViewController(previewVC, animated: true)
    }
    @IBAction func captureActionDidtapped(_ sender: Any) {
       handleDidTapRecord()
        
    }
    @IBAction func disCardBTNDidTapped(_ sender: Any) {
        let alertVC = UIAlertController(title: "discard the last clip ? ", message: nil, preferredStyle: .alert)
        let discardAction = UIAlertAction(title: "discard", style: .default){ [weak self] (_) in
            self?.handleDisCardLastRecordedClip()
        }
        let keepAction =  UIAlertAction(title: "keep", style: .cancel){ (_) in
            
        }
        alertVC.addAction(discardAction)
        alertVC.addAction(keepAction)
        present(alertVC, animated: true)
    }
    
    func handleDisCardLastRecordedClip(){
        print("discard")
        outputURL = nil
        thumbnailImage = nil
        recordedClips.removeLast()
        handleResetAllVisibilityToIndentity()
        handleSetNewOutputURLAndThumbnailImage()
        segmentedProgressView.handleRemoveLastSegment()
        
        if recordedClips.isEmpty == true{
            self.handleResetTimerAndProgressViewToZero()
        }else if recordedClips.isEmpty == false{
            self.handleCalculateDurationLeft()
        }
    }
    func handleCalculateDurationLeft(){
        let timeToDisCard = videoDurationOfLastClip
        let currentCombineTime = total_recordTime_In_Secs
        let newVideoDuration = currentCombineTime - timeToDisCard
        total_recordTime_In_Secs = newVideoDuration
        let countDownSec:Int = Int(currentMaxRecordingDuration) - total_recordTime_In_Secs / 10
        timerCounterLabel.text = "\(countDownSec)"
    }
    func handleSetNewOutputURLAndThumbnailImage(){
        outputURL = recordedClips.last?.videoUrl
        let currentURL:URL? = outputURL
        guard let currentUrlUnwrapped = currentURL else {return}
        guard let generatedThumbnailImage = generateVideoTHumbnail(withFile: currentUrlUnwrapped) else{return}
        if currentCameraDevice?.position == .front{
            thumbnailImage = didTakePicture(generatedThumbnailImage, to: .upMirrored)
        }else{
            thumbnailImage = generatedThumbnailImage
        }
    }
    func handleDidTapRecord(){
        if moviFileOutput.isRecording == false {
            startRecording()
        }else{
            stopRecording()
        }
    }
    func setupCaptureSession() -> Bool{
        capturesession.sessionPreset = AVCaptureSession.Preset.high
        
        if let captureVideoDevice = AVCaptureDevice.default(for: AVMediaType.video),
           let captureAudioDevice = AVCaptureDevice.default(for: AVMediaType.audio){
            do {
                let inputVideo = try AVCaptureDeviceInput(device: captureVideoDevice)
                let inputAudio = try AVCaptureDeviceInput(device: captureAudioDevice)
                
                if capturesession.canAddInput(inputVideo){
                    capturesession.addInput(inputVideo)
                    actionInput = inputVideo
                }
                if capturesession.canAddInput(inputAudio){
                    capturesession.addInput(inputAudio)
                }
                if capturesession.canAddOutput(moviFileOutput){
                    capturesession.addOutput(moviFileOutput)
                }
            }catch let error{
                print("could not setup camera input : ",error)
                return false
            }
        }
        if capturesession.canAddOutput(photoFileOutput){
            capturesession.addOutput(photoFileOutput)
        }
        //setup output previews
        let previewLayer = AVCaptureVideoPreviewLayer(session: capturesession)
        previewLayer.frame = view.frame
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        return true
    }
  
    @IBAction func flipbuttondidtapped(_ sender: Any) {
        capturesession.beginConfiguration()
        
        let currentInput = capturesession.inputs.first as? AVCaptureDeviceInput
        let newCameraDevice = currentInput?.device.position == .back ? getDeviceFront(position: .front) : getDeviceBack(position: .back)
        
        let newVideoInput = try? AVCaptureDeviceInput(device: newCameraDevice!)
        if let inputs = capturesession.inputs as? [AVCaptureDeviceInput]{
            for input in inputs {
                capturesession.removeInput(input)
            }
        }
        if capturesession.inputs.isEmpty{
            capturesession.addInput(newVideoInput!)
            actionInput = newVideoInput
        }
        if let microphone = AVCaptureDevice.default(for: .audio){
            do{
                let micInput = try AVCaptureDeviceInput(device: microphone)
                if capturesession.canAddInput(micInput){
                    capturesession.addInput(micInput)
                }
            }catch let micInputError{
                print("error setting device audio input : ",micInputError)
            }
        }
        capturesession.commitConfiguration()
    }
    func getDeviceFront(position:AVCaptureDevice.Position) -> AVCaptureDevice?{
        AVCaptureDevice.default(.builtInWideAngleCamera,for: .video,position: .front)
        
    }
    func getDeviceBack(position:AVCaptureDevice.Position) -> AVCaptureDevice?{
        AVCaptureDevice.default(.builtInWideAngleCamera,for: .video,position: .back)
        
    }
    @IBAction func handleDissmiss(_ sender: Any) {
        tabBarController?.selectedIndex = 0
    }
    func tempUrl() ->URL?{
        let directory = NSTemporaryDirectory() as NSString
        
        if directory != ""{
            let path = directory.appendingPathComponent(NSUUID().uuidString + ".mp4")
            return URL(fileURLWithPath: path)
        }
        return nil
    }
    func startRecording(){
        if moviFileOutput.isRecording == false{
            guard let connection = moviFileOutput.connection(with: .video) else{return}
            if connection.isVideoOrientationSupported{
                connection.preferredVideoStabilizationMode = AVCaptureVideoStabilizationMode.auto
                let device = actionInput.device
                if device.isSmoothAutoFocusSupported{
                    do{
                        try device.lockForConfiguration()
                        device.isSmoothAutoFocusEnabled = false
                        device.unlockForConfiguration()
                    }catch{
                         print("error setting configutation : ",error)
                    }
                }
                outputURL = tempUrl()
                moviFileOutput.startRecording(to: outputURL, recordingDelegate: self)
                handleAnimationRecordBtn()
            }
        }
    }
    func stopRecording(){
        if moviFileOutput.isRecording == true {
            moviFileOutput.stopRecording()
            stopTimer()
            segmentedProgressView.pauseProgress()
            handleAnimationRecordBtn()
            print("stop the count")
        }
    }
    func handleAnimationRecordBtn(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations:  { [weak self] in
            guard let self = self else {return}
            if self.isRecording == false {
                self.captureButton.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                self.captureButton.layer.cornerRadius = 5
                self.captureButtonView.transform = CGAffineTransform(scaleX: 1.7, y: 1.7)
                
                self.savedBTN.alpha = 0
                self.discadBTN.alpha = 0
                
//                flipbtn.layer.isHidden = true
//                fliplabel.layer.isHidden = true
//                speedbtn.layer.isHidden = true
//                speedlabel.layer.isHidden = true
//                beautybtn.layer.isHidden = true
//                beautylabel.layer.isHidden = true
//                filterbtn.layer.isHidden = true
//                filterlabel.layer.isHidden = true
//                timerbtn.layer.isHidden = true
//                timerlabel.layer.isHidden = true
                flashbtn.layer.isHidden = true
                flashlabel.layer.isHidden = true
                timesslabel.layer.isHidden = true
                souldview.layer.isHidden = true
                souldimage.layer.isHidden = true
                souldlabel.layer.isHidden = true
               
            }
            else{
                self.captureButton.transform = CGAffineTransform.identity
                self.captureButton.layer.cornerRadius = 68/2
                self.captureButtonView.transform = CGAffineTransform.identity
                
                self.handleResetAllVisibilityToIndentity()
            }
        }){[weak self] onComplete in
            guard let self = self else {return}
            self.isRecording = !self.isRecording
        }
    }
    func handleResetAllVisibilityToIndentity(){
        if recordedClips.isEmpty == true{
//            flipbtn.layer.isHidden = false
//            fliplabel.layer.isHidden = false
//            speedbtn.layer.isHidden = false
//            speedlabel.layer.isHidden = false
//            beautybtn.layer.isHidden = false
//            beautylabel.layer.isHidden = false
//            filterbtn.layer.isHidden = false
//            filterlabel.layer.isHidden = false
//            timerbtn.layer.isHidden = false
//            timerlabel.layer.isHidden = false
            flashbtn.layer.isHidden = false
            flashlabel.layer.isHidden = false
            timesslabel.layer.isHidden = false
            souldview.layer.isHidden = false
            souldimage.layer.isHidden = false
            souldlabel.layer.isHidden = false
            
            self.savedBTN.alpha = 0
            self.discadBTN.alpha = 0
            print("recoredClip: is Employ")
        }else{
            self.savedBTN.alpha = 1
            self.discadBTN.alpha = 1
            
//            flipbtn.layer.isHidden = true
//            fliplabel.layer.isHidden = true
//            speedbtn.layer.isHidden = true
//            speedlabel.layer.isHidden = true
//            beautybtn.layer.isHidden = true
//            beautylabel.layer.isHidden = true
//            filterbtn.layer.isHidden = true
//            filterlabel.layer.isHidden = true
//            timerbtn.layer.isHidden = true
//            timerlabel.layer.isHidden = true
            flashbtn.layer.isHidden = true
            flashlabel.layer.isHidden = true
            timesslabel.layer.isHidden = true
            souldview.layer.isHidden = true
            souldimage.layer.isHidden = true
            souldlabel.layer.isHidden = true
            print("recoredClip: not is Employ")
        }
        
//        if setupCaptureSession(){
//            DispatchQueue.global(qos: .background).async {
//                self.capturesession.startRunning()
//            }
//        }
    }
}
extension CreatePostViewController:AVCaptureFileOutputRecordingDelegate{
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if error != nil {
            print("error recording movie : ",error?.localizedDescription)
        }else{
            let URLOfVideoRecorded = outputURL! as URL
            guard let generatedThumbnailImage = generateVideoTHumbnail(withFile: URLOfVideoRecorded) else {return}
            if currentCameraDevice?.position == .front {
                thumbnailImage = didTakePicture(generatedThumbnailImage, to: .upMirrored)
            }else{
                thumbnailImage = generatedThumbnailImage
            }
        }
    }
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        let newRecordedClip = videoClips(videoUrl: fileURL, cameraPosition: currentCameraDevice?.position)
        recordedClips.append(newRecordedClip)
        
        print("recordClips : ",recordedClips.count)
        startTimer()
    }
    func didTakePicture(_ picture: UIImage, to orientation: UIImage.Orientation) -> UIImage{
        let flipedImage = UIImage(cgImage: picture.cgImage!, scale: picture.scale, orientation: orientation)
        return flipedImage
        
    }
    func generateVideoTHumbnail(withFile videourl:URL) -> UIImage? {
        let asset = AVAsset(url: videourl)
        
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        
        do{
            let cmTime = CMTimeMake(value: 1, timescale: 60)
            let thumbnailCGImage = try imageGenerator.copyCGImage(at: cmTime, actualTime: nil)
            return UIImage(cgImage: thumbnailCGImage)
        }catch let error{
            print(error)
        }
        return nil
    }
    
}
//MARK RECORDING TIMER
extension CreatePostViewController{
    func startTimer(){
        videoDurationOfLastClip = 0
        stopTimer()
        recordingTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { [weak self] _ in
            self?.timerKick()
        })
    }
    func timerKick(){
        total_recordTime_In_Secs += 1
        videoDurationOfLastClip += 1
        
        let time_limit = currentMaxRecordingDuration * 10
        if total_recordTime_In_Secs == time_limit {
            handleDidTapRecord()
        }
        let startTime = 0
        let trimmitTime:Int = Int(currentMaxRecordingDuration) - startTime
        let posotiveOrZero = max(total_recordTime_In_Secs, 0)
        let progress = Float(posotiveOrZero) / Float(trimmitTime) / 10
        segmentedProgressView.setProgress(CGFloat(progress))
        let countDownSec:Int = Int(currentMaxRecordingDuration) - total_recordTime_In_Secs / 10
        timerCounterLabel.text = "\(countDownSec)s"
    }
    
    func stopTimer(){
        recordingTimer?.invalidate()
    }
    func handleResetTimerAndProgressViewToZero(){
        total_recordTime_In_Secs = 0
        total_recordTime_In_Minutes = 0
        videoDurationOfLastClip = 0
        stopTimer()
        segmentedProgressView.setProgress(0)
        timerCounterLabel.text = "\(currentMaxRecordingDuration)s"
    }
}
