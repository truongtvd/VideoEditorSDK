//
//  VEFile.swift
//  VideoEditorSDK
//
//  Created by oneweek on 10/16/18.
//  Copyright © 2018 Harry Nguyen. All rights reserved.
//

import UIKit
import AVFoundation

public enum VEInputType {
    case document
    case cache
    case project
}

public class VEFile {
    public class func url(_ from:VEInputType = .document,name:String)->URL?{
        if from == .document {
            let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(name)
            return url
        }else if from == .cache {
            let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0].appendingPathComponent(name)
            return url
        }else if from == .project {
            let names = name.components(separatedBy: ".")
            let url = Bundle.main.url(forResource: names[0], withExtension: names[1])
            return url
        }else{
            return nil
        }
    }
    
    
    public class func asset(_ from:VEInputType = .document,name:String)->AVAsset?{
        if let p = self.url(from, name: name) {
            return AVAsset(url: p)
        }
        return nil
    }
}
