//
//  VEModel.swift
//  VideoEditorSDK
//
//  Created by oneweek on 10/18/18.
//

import UIKit
import AVFoundation

public struct MergeItem {
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
