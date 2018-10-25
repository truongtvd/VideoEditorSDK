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
    public static let shared = VEManager()
    var asset : VEAssetExportSession? = nil
    
    public func removeAudioFromVideo(_ videoURL: URL,
                                           outputURL:URL,
                                           outputFileType:AVFileType,
                                           quality:String = AVAssetExportPresetHighestQuality,
                                           progress:@escaping (_ export:AVAssetExportSession?)->Void,
                                           completion:@escaping (_ export:AVAssetExportSession?)->Void)
    {
        try? FileManager.default.removeItem(at: outputURL)
        
        let videoAsset = AVAsset(url: videoURL)
        let composition = AVMutableComposition()
        composition.add(type: .video , preferredID: kCMPersistentTrackID_Invalid, start: kCMTimeZero, duration: videoAsset.duration, track: videoAsset.tracks(withMediaType: .video)[0], at: kCMTimeZero)
        self.asset = VEAssetExportSession(asset: composition, quality: quality, fileType: outputFileType, outputURL: outputURL, composition: nil)
        self.asset?.closureProgress = {
            progress(self.asset?.session)
        }
        self.asset?.session?.exportAsynchronously {
            if self.asset?.session?.status == .completed {
                self.asset?.offTimer()
            }
            completion(self.asset?.session)
        }
    }
    
    
    public class func getAllFrames(urlVideo:URL,eachSeconds:Int = 1)->[UIImage] {
        var frames:[UIImage] = []
        let asset:AVAsset = AVAsset(url:urlVideo)
        let duration:Float64 = CMTimeGetSeconds(asset.duration)
        let generator = AVAssetImageGenerator(asset:asset)
        generator.appliesPreferredTrackTransform = true
        
        for index in stride(from: 0, to: Int(duration), by: eachSeconds) {
            let time:CMTime = CMTimeMakeWithSeconds(Float64(index), 600)
            if let image = try? generator.copyCGImage(at: time , actualTime: nil) {
                frames.append(UIImage(cgImage:image))
            }
        }
        return frames
    }
    
    
}
