//
//  VEFile.swift
//  VideoEditorSDK
//
//  Created by oneweek on 10/16/18.
//  Copyright © 2018 Harry Nguyen. All rights reserved.
//

import UIKit
import AVFoundation

enum InputType {
    case document
    case cache
    case project
}

class VEFile {
    class func path(_ from:InputType = .document,name:String)->URL?{
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
    
    class func existFile(url:URL){
        if FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.removeItem(at: url)
            }catch (let error){
                print("error = \(error.localizedDescription)")
            }
        }
    }
    
    class func asset(_ from:InputType = .document,name:String)->AVAsset?{
        if let p = self.path(from, name: name) {
            return AVAsset(url: p)
        }
        return nil
    }
}
