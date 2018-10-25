//
//  SMImageViewWithMask.swift
//  CropViewController
//
//  Created by Nguyễn Đình Đông on 10/22/18.
//

import Foundation
@IBDesignable
class SMImageViewWithMask : UIImageView {
    
    var imageToMaskView = UIImageView()
    var maskingImageView = UIImageView()
    
    @IBInspectable
    var shadowOpacity: Float = 0 {
        didSet {
            layer.shadowOpacity = shadowOpacity
        }
    }
    
    
    @IBInspectable
    var imageToMask : UIImage? {
        didSet {
            imageToMaskView.image = imageToMask
            updateView()
        }
    }
    
    func updateView() {
        if imageToMaskView.image != nil {
            imageToMaskView.frame = bounds
            imageToMaskView.contentMode = .scaleAspectFit
            
            maskingImageView.image = image //the mask
            maskingImageView.frame = bounds
            maskingImageView.contentMode = .center
            
            imageToMaskView.layer.mask = maskingImageView.layer
            addSubview(imageToMaskView)
        }
    }
    
}
