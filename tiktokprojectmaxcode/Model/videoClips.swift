//
//  videoClips.swift
//  tiktokprojectmaxcode
//
//  Created by quocanhppp on 25/04/2024.
//

import UIKit
import AVKit

struct videoClips:Equatable {
    let videoUrl:URL
    let cameraPosition: AVCaptureDevice.Position
    
    init(videoUrl:URL,cameraPosition:AVCaptureDevice.Position?){
        self.videoUrl = videoUrl
        self.cameraPosition = cameraPosition ?? .back
    }
    static func == (lhs:videoClips, rhs:videoClips) -> Bool{
        return lhs.videoUrl == rhs.videoUrl && lhs.cameraPosition == rhs.cameraPosition
    }
}
