//
//  VEWaterMark.swift
//  VideoEditorSDK
//
//  Created by oneweek on 10/18/18.
//

import UIKit
import AVFoundation


public enum VEWatermarkPosition {
    case TopLeft
    case TopRight
    case BottomLeft
    case BottomRight
    case Default
}

public struct VEWaterMarkText {
    let text : String
    let font : UIFont
    let fontSize : CGFloat
    let backgroundColor : UIColor
    let bounds : CGRect
}


public class VEWaterMark {

    public func watermark(videoAsset:AVAsset, text:VEWaterMarkText,outputURL:URL,outputFileType:AVFileType, position : VEWatermarkPosition, completion : @escaping (_ outputURL : URL, _ error:Error?)->Void) {
        self.watermark(videoAsset: videoAsset, text: text , waterMarkImage: nil , outputURL: outputURL, outputFileType: outputFileType, position: position) { (outputURL, error) in
            completion(outputURL,error)
        }
    }
    
    public func watermark(videoAsset:AVAsset, image:UIImage,outputURL:URL,outputFileType:AVFileType, position : VEWatermarkPosition, completion : @escaping (_ outputURL : URL, _ error:Error?)->Void) {
        self.watermark(videoAsset: videoAsset, text: nil , waterMarkImage: image , outputURL: outputURL, outputFileType: outputFileType, position: position) { (outputURL, error) in
            completion(outputURL,error)
        }
    }
    
    func watermark(videoAsset:AVAsset,  text : VEWaterMarkText?, waterMarkImage: UIImage?,outputURL:URL,outputFileType:AVFileType, position : VEWatermarkPosition,completion : @escaping (_ outputURL : URL, _ error:Error?) -> Void) {
        
        DispatchQueue.global().async {
            
            let mixComposition = AVMutableComposition()
            let clipVideoTrack = videoAsset.tracks(withMediaType: .video)[0]
            
            mixComposition.add(type: .video , preferredID: Int32(kCMPersistentTrackID_Invalid), start: .zero, duration: videoAsset.duration, track: videoAsset.tracks(withMediaType: .video)[0], at: .zero)
            
            let videoSize = clipVideoTrack.naturalSize
            
            let parentLayer = CALayer()
            let videoLayer = CALayer()
            parentLayer.frame = CGRect(x: 0, y: 0, width: videoSize.width , height: videoSize.height)
            videoLayer.frame = CGRect(x:0,y: 0,width: videoSize.width,height: videoSize.height)
            parentLayer.addSublayer(videoLayer)
            
            if let item = text {
                let titleLayer = CATextLayer()
                titleLayer.backgroundColor = item.backgroundColor.cgColor
                titleLayer.string = item.text
                titleLayer.font = item.font
                titleLayer.fontSize = item.fontSize
                titleLayer.alignmentMode = .center
                titleLayer.bounds = item.bounds
                parentLayer.addSublayer(titleLayer)
            } else if let img = waterMarkImage {
                let imageLayer = CALayer()
                imageLayer.contents = img.cgImage
                
                var xPosition : CGFloat = 0.0
                var yPosition : CGFloat = 0.0
                let imageSize : CGFloat = 57.0
                
                switch (position) {
                case .TopLeft:
                    xPosition = 0
                    yPosition = 0
                    break
                case .TopRight:
                    xPosition = videoSize.width - imageSize
                    yPosition = 0
                    break
                case .BottomLeft:
                    xPosition = 0
                    yPosition = videoSize.height - imageSize
                    break
                case .BottomRight, .Default:
                    xPosition = videoSize.width - imageSize
                    yPosition = videoSize.height - imageSize
                    break
                }
                
                
                imageLayer.frame = CGRect(x:xPosition,y: yPosition,width: imageSize,height: imageSize)
                imageLayer.opacity = 0.65
                parentLayer.addSublayer(imageLayer)
            }
            
            let videoComp = AVMutableVideoComposition()
            videoComp.renderSize = videoSize
            videoComp.frameDuration = CMTimeMake(value: 1, timescale: 30)
            videoComp.animationTool = AVVideoCompositionCoreAnimationTool(postProcessingAsVideoLayer: videoLayer, in: parentLayer)
            
            let instruction = AVMutableVideoCompositionInstruction()
            instruction.timeRange = CMTimeRangeMake(start: .zero , duration: mixComposition.duration)
            let videoTrack = mixComposition.tracks(withMediaType: .video)[0]
            
            let layerInstruction = self.videoCompositionInstruction(videoTrack, asset: videoAsset)
            
            instruction.layerInstructions = [layerInstruction]
            videoComp.instructions = [instruction]
            
            
            
            guard let exporter = AVAssetExportSession(asset: mixComposition, presetName: AVAssetExportPresetHighestQuality) else {return}
            exporter.outputURL = outputURL
            exporter.outputFileType = outputFileType
            exporter.shouldOptimizeForNetworkUse = true
            exporter.videoComposition = videoComp
            
            exporter.exportAsynchronously {
                DispatchQueue.main.async {
                    if exporter.status == .completed {
                        completion(outputURL,nil)
                    }else{
                        completion(outputURL,exporter.error)
                    }
                }
            }
        }
    }
    
    
    public func orientationFromTransform(_ transform: CGAffineTransform)
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
    public func videoCompositionInstruction(_ track: AVCompositionTrack, asset: AVAsset)
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
    func add(type:AVMediaType,preferredID:CMPersistentTrackID,start:CMTime,duration:CMTime,track:AVAssetTrack,at:CMTime){
        if let t = self.addMutableTrack(withMediaType: type, preferredTrackID: preferredID) {
            do {
                try t.insertTimeRange(CMTimeRangeMake(start: start, duration: duration), of: track, at: at)
            }catch (let error){
                print("error = \(error.localizedDescription)")
            }
        }
    }
}
