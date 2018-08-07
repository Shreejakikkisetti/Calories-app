//
//  ThirdHelperViewController.swift
//  Calories app
//
//  Created by Shreeja Kikkisetti on 8/6/18.
//  Copyright © 2018 Shreeja Kikkisetti. All rights reserved.
//


import Foundation
import UIKit
import AVKit
import AVFoundation

class ThirdHelperViewController: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        playVideo()
        
    }
    
    private func playVideo() {
        
        guard let path = Bundle.main.path(forResource: "videoThree", ofType: "mov") else {
            debugPrint("Video.mov not found")
            return
        }
        let player = AVPlayer(url: URL(fileURLWithPath: path))
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = CGRect(x: 15, y: 175, width: 350, height: 400)
        self.view.layer.addSublayer(playerLayer)
        player.play()
        loopVideo(videoPlayer: player)
        
    }
    
    private func loopVideo(videoPlayer: AVPlayer) {
        NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil, queue: nil) { notification in
            videoPlayer.seek(to: kCMTimeZero)
            videoPlayer.play()
        }
    }
}
