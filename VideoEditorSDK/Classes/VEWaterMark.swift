//
//  VEWaterMark.swift
//  VideoEditorSDK
//
//  Created by oneweek on 10/18/18.
//

import UIKit
import AVFoundation


public enum VEWatermarkPosition {
    case topLeft
    case topRight
    case bottomLeft
    case bottomRight
    case point
}

public struct VEWaterMarkPhoto {
    var photo : UIImage!
    var point : CGPoint = CGPoint.zero
    var position : VEWatermarkPosition = .point
    var size : CGSize = CGSize(width: 57.0, height: 57.0)
    var opacity : Float = 0.65
    
    public init (_ photo : UIImage,
                 point:CGPoint = CGPoint.zero,
                 position:VEWatermarkPosition = .point ,
                 size:CGSize = CGSize(width: 57.0, height: 57.0),
                 opacity : Float = 0.65){
        self.photo = photo
        self.point = point
        self.position = position
        self.size = size
        self.opacity = opacity
    }
}

public class VEWaterMarkText {
    public var text : String!
    public var textColor : UIColor!
    public var font : CFTypeRef!
    public var fontSize : CGFloat!
    public var backgroundColor : UIColor!
    public var point : CGPoint!
    
    public init(_ text:String,
                textColor:UIColor = .white,
         font:CFTypeRef = "HelveticaNeue" as CFTypeRef,
         fontSize:CGFloat = 20,
         bgColor:UIColor = .black,
         point:CGPoint = CGPoint(x: 10, y: 10)) {
        
        self.text = text
        self.textColor = textColor
        self.font = font
        self.fontSize = fontSize
        self.backgroundColor = bgColor
        self.point = point
    }
}


extension VEManager {
    public func watermark(videoAsset:AVAsset,
                   text : VEWaterMarkText? = nil,
                   waterMarkImage: VEWaterMarkPhoto? = nil,
                   outputURL:URL,
                   quality:String = AVAssetExportPresetHighestQuality,
                   outputFileType:AVFileType,
                   progress : @escaping (_ export : AVAssetExportSession?) -> Void,
                   completion : @escaping (_ outputURL : URL, _ error:Error?) -> Void)
    {
        let mixComposition = AVMutableComposition()
        let clipVideoTrack = videoAsset.tracks(withMediaType: .video)[0]
        
        mixComposition.add(type: .video ,
                           preferredID: Int32(kCMPersistentTrackID_Invalid),
                           start: kCMTimeZero,
                           duration: videoAsset.duration,
                           track: clipVideoTrack,
                           at: kCMTimeZero)
        mixComposition.add(type: .audio ,
                           preferredID: Int32(0),
                           start: kCMTimeZero,
                           duration: videoAsset.duration,
                           track: videoAsset.tracks(withMediaType: .audio)[0],
                           at: kCMTimeZero)
        
        let videoSize = clipVideoTrack.naturalSize
        
        let parentLayer = CALayer()
        let videoLayer = CALayer()
        parentLayer.frame = CGRect(x: 0, y: 0, width: videoSize.width , height: videoSize.height)
        videoLayer.frame = CGRect(x:0,y: 0,width: videoSize.width,height: videoSize.height)
        parentLayer.addSublayer(videoLayer)
        
        if let item = text {
            let titleLayer = CATextLayer()
            titleLayer.backgroundColor = item.backgroundColor.cgColor
            titleLayer.foregroundColor = item.textColor.cgColor
            titleLayer.string = item.text
            titleLayer.font = item.font
            titleLayer.fontSize = item.fontSize
            titleLayer.alignmentMode = kCAAlignmentCenter
            titleLayer.bounds = CGRect(x: 0, y: 0, width: videoSize.width , height: videoSize.height)
            titleLayer.position = item.point
            parentLayer.addSublayer(titleLayer)
        }
        if let img = waterMarkImage {
            let imageLayer = CALayer()
            imageLayer.contents = img.photo.cgImage
            
            var xPosition : CGFloat = 0.0
            var yPosition : CGFloat = 0.0
            
            switch (img.position) {
            case .bottomLeft:
                xPosition = 0
                yPosition = 0
                break
            case .bottomRight:
                xPosition = videoSize.width - img.size.width
                yPosition = 0
                break
            case .topLeft:
                xPosition = 0
                yPosition = videoSize.height - img.size.height
                break
            case .topRight:
                xPosition = videoSize.width - img.size.width
                yPosition = videoSize.height - img.size.height
                break
            case .point :
                xPosition = img.point.x
                yPosition = img.point.y
                break
            }
            
            
            imageLayer.frame = CGRect(x:xPosition,y: yPosition,width: img.size.width,height: img.size.height)
            imageLayer.opacity = img.opacity
            parentLayer.addSublayer(imageLayer)
        }
        
        let videoComp = AVMutableVideoComposition()
        videoComp.renderSize = videoSize
        videoComp.renderScale = 1.0
        videoComp.frameDuration = CMTimeMake(1, 30)
        videoComp.animationTool = AVVideoCompositionCoreAnimationTool(postProcessingAsVideoLayer: videoLayer, in: parentLayer)
        
        let instruction = AVMutableVideoCompositionInstruction()
        instruction.timeRange = CMTimeRangeMake(kCMTimeZero , mixComposition.duration)
        let videoTrack = mixComposition.tracks(withMediaType: .video)[0]
        
        instruction.layerInstructions = [AVMutableVideoCompositionLayerInstruction(assetTrack: videoTrack)]
        videoComp.instructions = [instruction]
        
        
        self.asset = VEAssetExportSession(asset: mixComposition, quality: quality, fileType: outputFileType, outputURL: outputURL, composition: videoComp)
        self.asset?.closureProgress = {
            progress(self.asset?.session)
        }
        self.asset?.session?.exportAsynchronously {
            DispatchQueue.main.async {
                if self.asset?.session?.status == .completed {
                    completion(outputURL,nil)
                }else{
                    completion(outputURL,self.asset?.session?.error)
                }
            }

        }
    }
    
    
}

extension AVMutableComposition {
    func add(type:AVMediaType,preferredID:CMPersistentTrackID,start:CMTime,duration:CMTime,track:AVAssetTrack,at:CMTime){
        if let t = self.addMutableTrack(withMediaType: type, preferredTrackID: preferredID) {
            do {
                try t.insertTimeRange(CMTimeRangeMake(start, duration), of: track, at: at)
            }catch (let error){
                print("error = \(error.localizedDescription)")
            }
        }
    }
}
