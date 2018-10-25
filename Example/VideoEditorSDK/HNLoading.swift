//
//  HNLoading.swift
//  READIT
//
//  Created by oneweek on 9/29/17.
//  Copyright © 2017 Harry Nguyen. All rights reserved.
//

import UIKit
import JGProgressHUD

let appDelegate  = UIApplication.shared.delegate as! AppDelegate

class HNLoading: NSObject {
    static let shared = HNLoading()
    
    var hud : JGProgressHUD = {
        return JGProgressHUD(style: .dark)
    }()
    
    func loading(text:String? = nil,view:UIView? = nil ){
        if self.hud.isVisible {
            return
        }
        self.hud = JGProgressHUD(style:.dark)
        self.hud.textLabel.text = text
        self.hud.detailTextLabel.text = nil
        if let v = view {
            self.hud.show(in: v)
        }else{
            if let v = appDelegate.window {
                self.hud.show(in: v)
            }
        }
    }
    func upload(percent:Float,view:UIView? = nil ){
        if !self.hud.isVisible {
            self.hud.indicatorView = JGProgressHUDPieIndicatorView()
//            self.hud.textLabel.text = "Uploading"
        }
        self.hud.progress = percent
//        self.hud.detailTextLabel.text = String(format:"%.f",percent*100)+"%"
        
        if !self.hud.isVisible {
            if let v = view {
                self.hud.show(in: v)
            }else{
                if let v = appDelegate.window {
                    self.hud.show(in: v)
                }
            }
        }
    }
    
    func hide(){
        self.hud.dismiss()
    }
}
