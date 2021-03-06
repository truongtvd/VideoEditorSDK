//
//  VEMerge.swift
//  VideoEditorSDK
//
//  Created by Harry Nguyen on 15/10/18.
//  Copyright © 2018 Harry Nguyen. All rights reserved.
//

import UIKit
import AVKit

extension VEManager {
    public func mergeAudioToVideo(urlVideo:URL,
                                        urlAudio:URL,
                                        outputURL:URL,
                                        outputType:AVFileType,
                                        quality:String = AVAssetExportPresetHighestQuality,
                                        progress: @escaping (_ exporter:AVAssetExportSession?)->Void,
                                        completion:@escaping (_ export:AVAssetExportSession?)->Void)
    {
        try? FileManager.default.removeItem(at: outputURL)
        let mixComposition = AVMutableComposition()
        let assetVideo = AVAsset(url: urlVideo)
        let assetAudio = AVAsset(url:urlAudio)
        
        guard let videoTrack = mixComposition.addMutableTrack(withMediaType: .video , preferredTrackID: Int32(kCMPersistentTrackID_Invalid)) else {
            completion(nil)
            return
        }
        do {
            try videoTrack.insertTimeRange(CMTimeRangeMake(kCMTimeZero, assetVideo.duration), of: assetVideo.tracks(withMediaType: .video)[0], at: kCMTimeZero)
        }catch(let error){
            print("error = \(error.localizedDescription)")
            completion(nil)
        }
        guard let audioTrack = mixComposition.addMutableTrack(withMediaType: .audio , preferredTrackID: 0) else {
            completion(nil)
            return
        }
        do {
            try audioTrack.insertTimeRange(CMTimeRangeMake(kCMTimeZero, assetVideo.duration), of: assetAudio.tracks(withMediaType: .audio)[0], at: kCMTimeZero)
        }catch(let error){
            print("error = \(error.localizedDescription)")
        }
        
        self.asset = VEAssetExportSession(asset: mixComposition, quality: quality, fileType: outputType, outputURL: outputURL, composition: nil)
        self.asset?.closureProgress = {
            progress(self.asset?.session)
        }
        self.asset?.session?.exportAsynchronously {
            completion(self.asset?.session)
        }
    }
    
    
    public func mergeVideos(withFileURLs videoFileURLs: [URL],
                                  outputURL:URL?,
                                  mediaType:AVFileType,
                                  quality:String = AVAssetExportPresetHighestQuality,
                                  progress: @escaping (_ exporter:AVAssetExportSession?)->Void,
                                  completion: @escaping (_ exporter:AVAssetExportSession?, _ error: Error?) -> Void)
    {
        
        let composition = AVMutableComposition()
        guard let videoTrack: AVMutableCompositionTrack = composition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid) else {
            completion(nil, NSError.message("Provide correct video file"))
            return
        }
        guard let audioTrack: AVMutableCompositionTrack = composition.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid) else {
            completion(nil, NSError.message("Video file had no Audio track"))
            return
        }
        var instructions = [AVVideoCompositionInstructionProtocol]()
        var isError = false
        var currentTime: CMTime = kCMTimeZero
        var videoSize = CGSize.zero
        var highestFrameRate = 0
        for  videoFileURL in videoFileURLs {
            let options = [AVURLAssetPreferPreciseDurationAndTimingKey: true]
            let asset = AVURLAsset(url: videoFileURL, options: options)
            let videoAsset: AVAssetTrack? = asset.tracks(withMediaType: .video).first
            if videoSize.equalTo(CGSize.zero) {
                videoSize = (videoAsset?.naturalSize)!
            }
            if videoSize.height < (videoAsset?.naturalSize.height)! {
                videoSize.height = (videoAsset?.naturalSize.height)!
            }
            if videoSize.width < (videoAsset?.naturalSize.width)! {
                videoSize.width = (videoAsset?.naturalSize.width)!
            }
        }
        
        for  videoFileURL in videoFileURLs {
            let options = [AVURLAssetPreferPreciseDurationAndTimingKey: true]
            let asset = AVURLAsset(url: videoFileURL, options: options)
            guard let videoAsset: AVAssetTrack = asset.tracks(withMediaType: .video).first else {
                completion(nil, NSError.message("Provide correct video file"))
                return
            }
            guard let audioAsset: AVAssetTrack = asset.tracks(withMediaType: .audio).first else {
                completion(nil, NSError.message("Video file had no Audio track"))
                return
            }
            let currentFrameRate = Int(roundf((videoAsset.nominalFrameRate)))
            highestFrameRate = (currentFrameRate > highestFrameRate) ? currentFrameRate : highestFrameRate
            let trimmingTime: CMTime = CMTimeMake(Int64(lround(Double((videoAsset.nominalFrameRate) / (videoAsset.nominalFrameRate)))), Int32((videoAsset.nominalFrameRate)))
            let timeRange: CMTimeRange = CMTimeRangeMake(trimmingTime, CMTimeSubtract((videoAsset.timeRange.duration), trimmingTime))
            do {
                try videoTrack.insertTimeRange(timeRange, of: videoAsset, at: currentTime)
                try audioTrack.insertTimeRange(timeRange, of: audioAsset, at: currentTime)
                
                let videoCompositionInstruction = AVMutableVideoCompositionInstruction.init()
                videoCompositionInstruction.timeRange = CMTimeRangeMake(currentTime, timeRange.duration)
                let layerInstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: videoTrack)
                
                var tx: Int = 0
                if videoSize.width - videoAsset.naturalSize.width != 0 {
                    tx = Int((videoSize.width - videoAsset.naturalSize.width) / 2)
                }
                var ty: Int = 0
                if videoSize.height - videoAsset.naturalSize.height != 0 {
                    ty = Int((videoSize.height - videoAsset.naturalSize.height) / 2)
                }
                var Scale = CGAffineTransform(scaleX: 1, y: 1)
                if tx != 0 && ty != 0 {
                    if tx <= ty {
                        let factor = Float(videoSize.width / videoAsset.naturalSize.width)
                        Scale = CGAffineTransform(scaleX: CGFloat(factor), y: CGFloat(factor))
                        tx = 0
                        ty = Int((videoSize.height - videoAsset.naturalSize.height * CGFloat(factor)) / 2)
                    }
                    if tx > ty {
                        let factor = Float(videoSize.height / videoAsset.naturalSize.height)
                        Scale = CGAffineTransform(scaleX: CGFloat(factor), y: CGFloat(factor))
                        ty = 0
                        tx = Int((videoSize.width - videoAsset.naturalSize.width * CGFloat(factor)) / 2)
                    }
                }
                let Move = CGAffineTransform(translationX: CGFloat(tx), y: CGFloat(ty))
                layerInstruction.setTransform(Scale.concatenating(Move), at: kCMTimeZero)
                videoCompositionInstruction.layerInstructions = [layerInstruction]
                instructions.append(videoCompositionInstruction)
                currentTime = CMTimeAdd(currentTime, timeRange.duration)
            } catch {
                print("Unable to load data: \(error)")
                isError = true
                completion(nil, error)
            }
        }
        if isError == false {
            let mutableVideoComposition = AVMutableVideoComposition.init()
            mutableVideoComposition.instructions = instructions
            mutableVideoComposition.frameDuration = CMTimeMake(1, Int32(highestFrameRate))
            mutableVideoComposition.renderSize = videoSize
            
            let urlDefault: URL = defaultOutputURL()
            if outputURL == nil {
                try? FileManager.default.removeItem(atPath: urlDefault.path)
            }else{
                try? FileManager.default.removeItem(atPath: outputURL?.path ?? "")
            }
            
            self.asset = VEAssetExportSession(asset: composition, quality:quality, fileType: mediaType, outputURL: outputURL ?? urlDefault, composition: mutableVideoComposition)
            self.asset?.closureProgress = {
                progress(self.asset?.session)
            }
            self.asset?.session?.exportAsynchronously {
                completion(self.asset?.session,self.asset?.session?.error)
            }
        }
    }
    public func defaultOutputURL() -> URL {
        return VEFile.url(.document, name: "\(UUID().uuidString)-mergedVideo.mp4")!
    }
}
extension NSError {
    class func message(_ message:String,_ code:Int = 404)->Error{
        return NSError(domain: Bundle.main.bundleIdentifier!, code: code , userInfo: ["Error":message])
    }
}
