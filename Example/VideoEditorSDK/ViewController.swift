//
//  ViewController.swift
//  VideoEditorSDK
//
//  Created by trungnk on 10/18/2018.
//  Copyright (c) 2018 trungnk. All rights reserved.
//

import UIKit
import VideoEditorSDK
import GPUImage

class ViewController: UIViewController {
    
    var movieFile = GPUImageMovie()
    var filter = GPUImageOutput()
    var movieWriter = GPUImageMovieWriter()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    
    
    @IBAction func mergeVideos(_ sender:Any){
        VEMerge.mergeVideos(withFileURLs: [VEFile.url(.project, name: "a.mp4")!,
                                           VEFile.url(.project, name: "b.mp4")!],
                            outputURL: VEFile.url(.document,name: "merged.mp4"),
                            mediaType: .mp4)
        { (exporter, error) in
            
        }
    }
    @IBAction func trimVideo(_ sender:Any){
        guard let url = VEFile.url(.project, name: "a.mp4") else {return}
//        guard let assetInput = VEFile.asset(.project, name: "a.mp4") else {return}
        self.movieFile = GPUImageMovie(url: url)
        self.movieFile.runBenchmark = true
        self.movieFile.playAtActualSpeed = false
        self.filter = GPUImagePixellateFilter()
        self.movieFile.addTarget(self.filter as? GPUImageInput)
        
        guard let output = VEFile.url(.document , name: "filter-video.mp4") else {
            return
        }
        try? FileManager.default.removeItem(at: output)
//        let size = assetInput.tracks(withMediaType: .video)[0].naturalSize
        self.movieWriter = GPUImageMovieWriter(movieURL: output, size: CGSize(width: 640, height: 480))
        self.filter.addTarget(self.movieWriter)
        self.movieWriter.shouldPassthroughAudio = true
        self.movieFile.audioEncodingTarget = self.movieWriter
        self.movieFile.enableSynchronizedEncoding(using: self.movieWriter)
        
        self.movieWriter.startRecording()
        self.movieFile.startProcessing()
        self.movieWriter.completionBlock = {
            self.filter.removeTarget(self.movieWriter)
            self.movieWriter.finishRecording()
            print("finish = \(output)")
        }
        
    }
    @IBAction func waterMarkTextVideo(_ sender:Any){
        
    }
    @IBAction func waterMarkImageVideo(_ sender:Any){
        
    }
    @IBAction func filterVideo(_ sender:Any){
        
    }
}
