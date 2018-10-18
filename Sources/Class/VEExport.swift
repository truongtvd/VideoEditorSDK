//
//  VEExport.swift
//  VideoEditorSDK
//
//  Created by oneweek on 10/16/18.
//  Copyright © 2018 Harry Nguyen. All rights reserved.
//

import UIKit
import AVFoundation


class VEExport: NSObject {
//    static let shared = VEExport()
//
//    var export : AVAssetExportSession?
    
    class func trim(asset:AVAsset,outputURL:URL,outputType:AVFileType,quality:String,startTime:Double,endTime:Double,completion:@escaping (_ outputURL:URL)->Void){
        VEFile.existFile(url: outputURL)
        guard let exportSession = AVAssetExportSession(asset: asset, presetName: quality) else { return }
        exportSession.outputURL = outputURL
        exportSession.outputFileType = outputType
        
        let timeRange = CMTimeRange(start: CMTime(seconds: startTime, preferredTimescale: 1000),
                                    end: CMTime(seconds: endTime, preferredTimescale: 1000))
        
        exportSession.timeRange = timeRange
        exportSession.exportAsynchronously {
            switch exportSession.status {
            case .completed:
                print("exported at \(outputURL)")
                completion(outputURL)
            case .failed:
                print("failed \(exportSession.error.debugDescription)")
            case .cancelled:
                print("cancelled \(exportSession.error.debugDescription)")
            default: break
            }
        }
    }
    
    
    class func merge(items:[MergeItem],size:CGSize,outputURL:URL,outputType:AVFileType,quality:String,completion:@escaping (_ outputURL:URL)->Void){
//        VEFile.existFile(url: outputURL)
        try? FileManager.default.removeItem(at: outputURL)
        let mixComposition = AVMutableComposition()
//        let mainInstruction = AVMutableVideoCompositionInstruction()
//        var totalTime = CMTime.zero
        
        guard let videoTrack = mixComposition.addMutableTrack(withMediaType: .video , preferredTrackID: Int32(kCMPersistentTrackID_Invalid)) else {
            return
        }
        guard let audioTrack = mixComposition.addMutableTrack(withMediaType: .audio , preferredTrackID: 0) else {
            return
        }
        for item in items {
//            totalTime = CMTimeAdd(totalTime, item.asset.duration)
            do {
                if item.type == .video {
                    try videoTrack.insertTimeRange(CMTimeRangeMake(start: item.startTime, duration: item.duration), of: item.asset.tracks(withMediaType: item.type)[0], at: item.at)
                }else{
                    try audioTrack.insertTimeRange(CMTimeRangeMake(start: item.startTime, duration: item.duration), of: item.asset.tracks(withMediaType: item.type)[0], at: item.at)
                }
            }catch (let error){
                print("error = \(error.localizedDescription)")
            }
//            let ins = self.videoCompositionInstruction(track, asset: item.asset)
//            ins.setOpacity(0.0, at: item.at)
//            mainInstruction.layerInstructions.append(ins)
        }
//        mainInstruction.timeRange = CMTimeRangeMake(start: .zero, duration: totalTime)
//
//        let mainComposition = AVMutableVideoComposition()
//        mainComposition.instructions = [mainInstruction]
//        mainComposition.frameDuration = CMTimeMake(value: 1, timescale: 30)
//        mainComposition.renderSize = size
        
        guard let exporter = AVAssetExportSession(asset: mixComposition,
                                                  presetName: quality) else {
                                                    return
        }
//        exporter.videoComposition = mainComposition
        exporter.outputURL = outputURL
        exporter.outputFileType = outputType
        exporter.shouldOptimizeForNetworkUse = true
        
        
        // 6 - Perform the Export
        exporter.exportAsynchronously {
            DispatchQueue.main.async {
                switch exporter.status {
                case .completed:
                    print("merge exported at \(outputURL)")
                    completion(outputURL)
                case .failed:
                    print("failed \(exporter.error.debugDescription)")
                case .cancelled:
                    print("cancelled \(exporter.error.debugDescription)")
                default: break
                }
            }
        }
    }
    
    static func orientationFromTransform(_ transform: CGAffineTransform)
        -> (orientation: UIImage.Orientation, isPortrait: Bool) {
            var assetOrientation = UIImage.Orientation.up
            var isPortrait = false
            if transform.a == 0 && transform.b == 1.0 && transform.c == -1.0 && transform.d == 0 {
                assetOrientation = .right
                isPortrait = true
            } else if transform.a == 0 && transform.b == -1.0 && transform.c == 1.0 && transform.d == 0 {
                assetOrientation = .left
                isPortrait = true
            } else if transform.a == 1.0 && transform.b == 0 && transform.c == 0 && transform.d == 1.0 {
                assetOrientation = .up
            } else if transform.a == -1.0 && transform.b == 0 && transform.c == 0 && transform.d == -1.0 {
                assetOrientation = .down
            }
            return (assetOrientation, isPortrait)
    }
    static func videoCompositionInstruction(_ track: AVCompositionTrack, asset: AVAsset)
        -> AVMutableVideoCompositionLayerInstruction {
            let instruction = AVMutableVideoCompositionLayerInstruction(assetTrack: track)
            let assetTrack = asset.tracks(withMediaType: .video)[0]
            
            let transform = assetTrack.preferredTransform
            let assetInfo = orientationFromTransform(transform)
            
            var scaleToFitRatio = UIScreen.main.bounds.width / assetTrack.naturalSize.width
            if assetInfo.isPortrait {
                scaleToFitRatio = UIScreen.main.bounds.width / assetTrack.naturalSize.height
                let scaleFactor = CGAffineTransform(scaleX: scaleToFitRatio, y: scaleToFitRatio)
                instruction.setTransform(assetTrack.preferredTransform.concatenating(scaleFactor), at: CMTime.zero)
            } else {
                let scaleFactor = CGAffineTransform(scaleX: scaleToFitRatio, y: scaleToFitRatio)
                var concat = assetTrack.preferredTransform.concatenating(scaleFactor)
                    .concatenating(CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.width / 2))
                if assetInfo.orientation == .down {
                    let fixUpsideDown = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
                    let windowBounds = UIScreen.main.bounds
                    let yFix = assetTrack.naturalSize.height + windowBounds.height
                    let centerFix = CGAffineTransform(translationX: assetTrack.naturalSize.width, y: yFix)
                    concat = fixUpsideDown.concatenating(centerFix).concatenating(scaleFactor)
                }
                instruction.setTransform(concat, at: CMTime.zero)
            }
            
            return instruction
    }
}
extension AVMutableComposition {
    func add(item:MergeItem){
        if let track = self.addMutableTrack(withMediaType: item.type, preferredTrackID: item.persistentID) {
            do {
                try track.insertTimeRange(CMTimeRangeMake(start: item.startTime, duration: item.duration), of: item.asset.tracks(withMediaType: item.type)[0], at: item.at)
            }catch (let error){
                print("error = \(error.localizedDescription)")
            }
        }
    }
}
struct MergeItem {
    let asset : AVAsset!
    let type : AVMediaType!
    let startTime : CMTime!
    let duration : CMTime!
    let at : CMTime!
    let persistentID : CMPersistentTrackID!
    
    init(asset:AVAsset,type:AVMediaType,startTime:CMTime = .zero,duration:CMTime?=nil,at:CMTime,persistentID:CMPersistentTrackID) {
        self.asset = asset
        self.duration = duration ?? asset.duration
        self.startTime = startTime
        self.type = type
        self.persistentID = persistentID
        self.at = at
    }
}
