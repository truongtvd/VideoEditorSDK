//
//  VEExport.swift
//  VideoEditorSDK
//
//  Created by oneweek on 10/16/18.
//  Copyright © 2018 Harry Nguyen. All rights reserved.
//

import UIKit
import AVFoundation


public class VETrim {
    
    public class func trim(asset:AVAsset,outputURL:URL,outputType:AVFileType,quality:String,startTime:Double,endTime:Double,completion:@escaping (_ export:AVAssetExportSession?)->Void){
        try? FileManager.default.removeItem(at: outputURL)
        guard let exportSession = AVAssetExportSession(asset: asset, presetName: quality) else { return }
        exportSession.outputURL = outputURL
        exportSession.outputFileType = outputType
        
        let timeRange = CMTimeRange(start: CMTime(seconds: startTime, preferredTimescale: 1000),
                                    end: CMTime(seconds: endTime, preferredTimescale: 1000))
        
        exportSession.timeRange = timeRange
        exportSession.exportAsynchronously {
            completion(exportSession)
        }
    }
    
    
}
