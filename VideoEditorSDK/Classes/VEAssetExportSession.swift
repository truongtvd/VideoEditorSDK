//
//  VEAssetExportSession.swift
//  VideoEditorSDK
//
//  Created by oneweek on 10/22/18.
//

import UIKit
import AVFoundation

public class VEAssetExportSession {
    
    var session : AVAssetExportSession? = nil 
    var timer : Timer? = nil
    var closureProgress : (()->Void)?
    
    deinit {
        self.timer?.invalidate()
        self.timer = nil
    }
    init(asset:AVAsset,
         quality:String = AVAssetExportPresetHighestQuality,
         fileType:AVFileType,
         outputURL:URL,
         composition:AVVideoComposition?) {
        
        self.session = AVAssetExportSession(asset: asset, presetName: quality)
        self.session?.outputFileType = fileType
        self.session?.outputURL = outputURL
        self.session?.shouldOptimizeForNetworkUse = true
        self.session?.videoComposition = composition
        
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self , selector: #selector(self.runTimer), userInfo: nil , repeats: true)
    }
    
    @objc func runTimer(){
        if self.session?.status == .completed {
            self.offTimer()
        }
        self.closureProgress?()
    }
    
    func offTimer(){
        self.timer?.invalidate()
        self.timer = nil
    }
    
}
