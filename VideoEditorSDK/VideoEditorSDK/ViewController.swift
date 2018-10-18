//
//  ViewController.swift
//  VideoEditorSDK
//
//  Created by oneweek on 10/15/18.
//  Copyright © 2018 Harry Nguyen. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer
import AVKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func preview(url:URL){
        let player = AVPlayer(url: url)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
    
    func mergeVideo(){
//        guard let assetOne = VEFile.asset(.document, name: "test.mp4") else {
//            return
//        }
//        guard let assetTwo = VEFile.asset(.project , name: "Viet-Nam-Da-LAB.mp4") else {
//            return
//        }
//        guard let outputUrl = VEFile.path(.document , name: "merged.mp4") else {
//            return
//        }
//        let one = MergeItem(asset: assetOne, type: .video, at: .zero, persistentID: Int32(kCMPersistentTrackID_Invalid))
//        let oneAudio = MergeItem(asset: assetOne, type: .audio, at: .zero, persistentID: 0)
//
//        let two = MergeItem(asset: assetTwo, type: .video, startTime: .zero, duration: assetTwo.duration, at: assetOne.duration, persistentID: Int32(kCMPersistentTrackID_Invalid))
//        let twoAudio = MergeItem(asset: assetTwo, type: .audio, startTime: .zero, duration: assetTwo.duration, at: assetOne.duration, persistentID: 0)
//
//        VEExport.merge(items: [one,oneAudio,two,twoAudio],size:assetOne.tracks(withMediaType: .video)[0].naturalSize, outputURL: outputUrl, outputType: .mp4, quality: AVAssetExportPresetHighestQuality) { (output) in
//            print("output url merge = \(output.absoluteString)")
//            self.preview(url: output)
//        }
        let output = VEFile.path(.document, name: "merged.mp4")
        
        guard let url1 = Bundle.main.url(forResource: "test", withExtension: "mp4") else {return }
        guard let url2 = Bundle.main.url(forResource: "splited", withExtension: "mp4") else {return }

        DPVideoMerger().mergeVideos(withFileURLs: [url1,url2], outputURL: output, mediaType: .mp4) { (outputURl, error) in
            if let err = error {
                print("error = \(err.localizedDescription)")
            }else{
                print("outputURL = \(outputURl!.absoluteString)")
                self.preview(url: outputURl!)
            }
        }
    }

    @IBAction func test(_ sender:Any){
        if let asset = VEFile.asset(.project, name: "Viet-Nam-Da-LAB.mp4"),
            let output = VEFile.path(.document, name: "test.mp4"){
            VEExport.trim(asset: asset, outputURL: output, outputType: .mp4, quality: AVAssetExportPresetHighestQuality, startTime: 10, endTime: 120) { (urlOutput) -> Void in
                print("output url = \(urlOutput.absoluteString)")
//                self.preview(url:urlOutput)
                self.mergeVideo()
            }
        }
    }

}
