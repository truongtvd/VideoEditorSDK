//
//  ViewController.swift
//  VideoEditorSDK
//
//  Created by trungnk on 10/18/2018.
//  Copyright (c) 2018 trungnk. All rights reserved.
//

import UIKit
import VideoEditorSDK
import MediaPlayer
import AVKit
import SMPhotoEditorSDK
import JGProgressHUD

class ViewController: UIViewController {
    var hud : JGProgressHUD = {
        return JGProgressHUD(style: .dark)
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    func preview(_ url:URL){
        DispatchQueue.main.async {
            let player = AVPlayer(url: url)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            self.present(playerViewController, animated: true) {
                playerViewController.player!.play()
            }
        }
    }
    func convert(cmage:CIImage) -> UIImage
    {
        let context:CIContext = CIContext.init(options: nil)
        let cgImage:CGImage = context.createCGImage(cmage, from: cmage.extent)!
        let image:UIImage = UIImage.init(cgImage: cgImage)
        return image
    }
    func hud(percent:Float){
        if !self.hud.isVisible {
            self.hud.indicatorView = JGProgressHUDPieIndicatorView()
        }
        self.hud.progress = percent
        if !self.hud.isVisible {
            self.hud.show(in: self.view)
        }
    }
    
    
    @IBAction func mergeVideos(_ sender:Any){
        self.hud(percent: 0.01)
        VEManager.shared.mergeVideos(withFileURLs: [VEFile.url(.project, name: "a.mp4")!,
                                             VEFile.url(.project, name: "b.mp4")!],
                              outputURL: VEFile.url(.document,name: "merged.mp4"),
                              mediaType: .mp4,
                              progress:
        { (export) in
            print("progress = \(String(describing: export?.progress))")
            if let pro = export?.progress {
                self.hud(percent: pro)
            }
        }) { (export , error) in
            self.hud.dismiss()
            if let err = error {
                print("error = \(err.localizedDescription)")
            }else {
                 print("status = \(String(describing: export?.status))")
                self.preview(export!.outputURL!)
            }
        }
    }
    @IBAction func trimVideo(_ sender:Any){
        self.hud(percent: 0.01)
        VEManager.shared.trim(asset: VEFile.asset(.project, name: "a.mp4")!,
                       outputURL: VEFile.url(.document, name: "trimed.mp4")!,
                       outputType: .mp4 ,
                       startTime: 10, endTime: 20,
                       progress:
        { (export ) in
            print("progress = \(String(describing: export?.progress))")
            if let pro = export?.progress {
                self.hud(percent: pro)
            }
        }) { (export) in
            self.hud.dismiss()
            print("status = \(String(describing: export?.status))")
            self.preview(export!.outputURL!)
        }
    }
    @IBAction func waterMarkTextVideo(_ sender:Any){
        HNLoading.shared.upload(percent: 0.01, view: self.view)
        let text = VEWaterMarkText("Harry Nguyen",textColor:.red, bgColor: UIColor.clear, point:CGPoint(x: 100, y: 100))
        guard let output = VEFile.url(.document, name: "waterText.mp4") else {return}
        try? FileManager.default.removeItem(at: output)
        
        VEManager.shared.watermark(videoAsset: VEFile.asset(.project , name: "b.mp4")!,
                            text: text,
                            outputURL: output,
                            outputFileType: .mp4,
                            progress:
        { export in
            print("progress = \(String(describing: export?.progress))")
            if let pro = export?.progress {
                HNLoading.shared.upload(percent: pro , view: self.view)
            }
        })
        { (outputURL, error ) in
            HNLoading.shared.hide()
            if let err = error {
                print("error = \(err.localizedDescription)")
            }else{
                print("outputURL = \(outputURL.absoluteString)")
                self.preview(output)
            }
        }
    }
    @IBAction func waterMarkImageVideo(_ sender:Any){
        self.hud(percent: 0.01)
        guard let output = VEFile.url(.document, name: "waterPhoto.mp4") else {return}
        try? FileManager.default.removeItem(at: output)

        let photo = VEWaterMarkPhoto(UIImage(named: "photo.jpeg")!,
                                     point: CGPoint(x: 100, y: 100),
                                     position: .point ,
                                     size: CGSize(width: 50, height: 50),
                                     opacity: 0.7)

        VEManager.shared.watermark(videoAsset: VEFile.asset(.project , name: "b.mp4")!,
                            waterMarkImage: photo  ,
                            outputURL: output,
                            outputFileType: .mp4,
                            progress:
        { export in
            print("progress = \(String(describing: export?.progress))")
            if let pro = export?.progress {
                self.hud(percent: pro)
            }
        })
        { (outputURL, error ) in
            self.hud.dismiss()
            if let err = error {
                print("error = \(err.localizedDescription)")
            }else{
                print("outputURL = \(outputURL.absoluteString)")
                self.preview(outputURL)
            }
        }
    }
    @IBAction func filterVideo(_ sender:Any){
        self.hud(percent: 0.01)
        guard let asset = VEFile.asset(.project, name: "a.mp4") else {return}
        guard let output = VEFile.url(.project, name: "filtered.mp4") else {return}
        let composition = AVVideoComposition(asset: asset, applyingCIFiltersWithHandler: { request in
            let source = request.sourceImage.clampedToExtent()
            let filter = SMImage.CIPhotoEffectInstant(source)
            let output = filter.cropped(to: request.sourceImage.extent)
            
            request.finish(with: output, context: nil)
        })
        VEManager.shared.filter(asset: asset ,
                         outputURL: output,
                         outputFileType: .mp4,
                         composition:composition,
                         progress:
        { (export) in
            print("progress = \(String(describing: export?.progress))")
            if let pro = export?.progress {
                self.hud(percent: pro)
            }
        }) { (export ) in
            self.hud.dismiss()
            if export?.status == .completed {
                print("status completed")
            }else{
                print("status other")
                self.preview(output)
            }
        }
    }
    
    @IBAction func removeAudioFromVideo(_ sender:Any){
        self.hud(percent: 0.01)
        guard let url = VEFile.url(.project, name: "a.mp4") else {return}
        guard let output = VEFile.url(.document, name: "removed.mp4") else {return}
        VEManager.shared.removeAudioFromVideo(url , outputURL: output, outputFileType: .mp4 , progress: { (export ) in
            print("statsus = \(String(describing: export?.status))")
            print("progress = \(String(describing: export?.progress))")
            if let pro = export?.progress {
                self.hud(percent: pro)
            }
        }) { (export) in
            self.hud.dismiss()
            print("statsus = \(String(describing: export?.status))")
            self.preview(output)
        }
    }
    
    @IBAction func previewFilterLiveVideo(_ sender:Any){
        guard let url = VEFile.url(.project, name: "a.mp4") else {return}
        
        let asset = AVAsset(url: url)
        let item = AVPlayerItem(url: url)
        let composition = AVVideoComposition(asset: asset, applyingCIFiltersWithHandler: { request in
            let source = request.sourceImage.clampedToExtent()
            let filter = SMImage.CIPhotoEffectInstant(source)
            let output = filter.cropped(to: request.sourceImage.extent)

            request.finish(with: output, context: nil)
        })
        item.videoComposition = composition

        let player = AVPlayer(playerItem: item)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
    
    
}
