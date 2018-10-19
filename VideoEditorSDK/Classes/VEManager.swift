//
//  VEManager.swift
//  VideoEditorSDK
//
//  Created by oneweek on 10/16/18.
//  Copyright © 2018 Harry Nguyen. All rights reserved.
//

import UIKit
import AVFoundation

public class VEManager {
    public class func removeAudioFromVideo(_ videoURL: URL,outputURL:URL,outputFileType:AVFileType,quality:String = AVAssetExportPresetHighestQuality, completion:@escaping (_ export:AVAssetExportSession?)->Void) {
        
        let videoAsset = AVAsset(url: videoURL)
        let composition = AVMutableComposition()
        composition.add(type: .video , preferredID: kCMPersistentTrackID_Invalid, start: .zero, duration: videoAsset.duration, track: videoAsset.tracks(withMediaType: .video)[0], at: .zero)
        guard let exporter = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetHighestQuality) else {return}
        exporter.outputFileType = outputFileType
        exporter.outputURL = outputURL
        try? FileManager.default.removeItem(at: outputURL)

        exporter.exportAsynchronously {
            completion(exporter)
        }
    }
    
    
    func getAllFrames(urlVideo:URL)->[UIImage] {
        var frames:[UIImage] = []
        let asset:AVAsset = AVAsset(url:urlVideo)
        let duration:Float64 = CMTimeGetSeconds(asset.duration)
        let generator = AVAssetImageGenerator(asset:asset)
        generator.appliesPreferredTrackTransform = true
        
        for index:Int in 0 ..< Int(duration) {
            let time:CMTime = CMTimeMakeWithSeconds(Float64(index), preferredTimescale:600)
            if let image = try? generator.copyCGImage(at: time , actualTime: nil) {
                frames.append(UIImage(cgImage:image))
            }
        }
        return frames
    }
    
    
}
