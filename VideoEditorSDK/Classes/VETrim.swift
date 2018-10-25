//
//  VEExport.swift
//  VideoEditorSDK
//
//  Created by oneweek on 10/16/18.
//  Copyright © 2018 Harry Nguyen. All rights reserved.
//

import UIKit
import AVFoundation


extension VEManager {
    
    public func trim(asset:AVAsset,
                           outputURL:URL,
                           outputType:AVFileType,
                           quality:String = AVAssetExportPresetHighestQuality,
                           startTime:Double,
                           endTime:Double,
                           progress:@escaping (_ export:AVAssetExportSession?)->Void,
                           completion:@escaping (_ export:AVAssetExportSession?)->Void)
    {
        try? FileManager.default.removeItem(at: outputURL)
        
        self.asset? = VEAssetExportSession(asset: asset , quality: quality, fileType: outputType, outputURL: outputURL, composition: nil)
        let timeRange = CMTimeRange(start: CMTime(seconds: startTime, preferredTimescale: 1000),
                                    end: CMTime(seconds: endTime, preferredTimescale: 1000))
        self.asset?.session?.timeRange = timeRange
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
    
    
}
