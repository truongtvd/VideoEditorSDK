//
//  VEModel.swift
//  VideoEditorSDK
//
//  Created by oneweek on 10/18/18.
//

import UIKit
import AVFoundation
import SMPhotoEditorSDK

extension VEManager {
    public func filter(asset:AVAsset,
                      outputURL:URL,
                      outputFileType:AVFileType,
                      quality:String = AVAssetExportPresetHighestQuality,
                      composition:AVVideoComposition,
                      progress:@escaping (_ export:AVAssetExportSession?)->Void,
                      completion:@escaping (_ export:AVAssetExportSession?)->Void){
        
        try? FileManager.default.removeItem(at: outputURL)
        
        self.asset = VEAssetExportSession(asset: asset , quality: quality, fileType: outputFileType, outputURL: outputURL, composition: composition)
        self.asset?.closureProgress = {
            progress(self.asset?.session)
        }
        self.asset?.session?.exportAsynchronously {
            completion(self.asset?.session)
        }
        
    }
}
