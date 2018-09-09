//
//  ViewController.swift
//  videoTest
//
//  Created by xiaoqiang cao on 7/1/18.
//  Copyright © 2018 xiaoqiang cao. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVCapturePhotoCaptureDelegate {
    @IBOutlet weak var videoStartBNT: UIButton!
    
    @IBOutlet weak var videoStopBTN: UIButton!
    
    let session = AVCaptureSession()
    
    let deviceInput = DeviceInput()
    
    var fileOutput: AVCaptureMovieFileOutput?
    
    @IBOutlet weak var forPreview: UIView!
    
    
    func settingPreviewLayer(){
        let previwLayer = AVCaptureVideoPreviewLayer()
        previwLayer.frame = forPreview.bounds
        previwLayer.session = session
        previwLayer.videoGravity = .resizeAspectFill
        forPreview.layer.addSublayer(previwLayer)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingPreviewLayer()
        session.addInput(deviceInput.microphone!)
        
        session.addInput(deviceInput.backWildAngleCamera!)
        
        //session.sessionPreset = .photo
        
        session.sessionPreset = .hd1280x720
        session.addOutput(AVCaptureMovieFileOutput())
        session.startRunning()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func frontBackToggle(_ sender: Any) {
        session.beginConfiguration()
        
        session.removeInput(session.inputs.last!)
        
        if (sender as AnyObject).isOn{
            session.addInput(deviceInput.backWildAngleCamera!)
        }else{
            session.addInput(deviceInput.frontWildAngleCamera!)
        }
        
        session.commitConfiguration()
    }
    
    
    
    @IBAction func dovideoStart(_ sender: Any) {
        print("start do recording ....")
//        let url = URL(fileURLWithPath: NSTemporaryDirectory() + "output.mov")
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        let fileUrl = paths[0].appendingPathComponent("output.mov")
        //try? FileManager.default.removeItem(at: fileUrl)
        
        let output = session.outputs.first! as! AVCaptureMovieFileOutput
        output.startRecording(to: fileUrl, recordingDelegate: self as AVCaptureFileOutputRecordingDelegate)
   
    }
    
    
    @IBAction func doVideoStop(_ sender: Any) {
        print("record stoped")
        let output = session.outputs.first! as! AVCaptureMovieFileOutput
        output.stopRecording()
    }
    
    
}

extension ViewController: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput,
                    didFinishRecordingTo outputFileURL: URL,
                    from connections: [AVCaptureConnection],
                    error: Error?) {
        // Handle output
    }
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(outputFileURL.path) {
            UISaveVideoAtPathToSavedPhotosAlbum(outputFileURL.path, self, #selector(completion(_:error:contextInfo:)), nil)
        }
    }
    @objc func completion(_ videoPath: String, error: Error?, contextInfo: Any?){
        do {
            let fm = FileManager.default
            try fm.removeItem(atPath: videoPath)
        } catch{
            print(error)
        }
    }
}


    

