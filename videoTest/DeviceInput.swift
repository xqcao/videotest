//
//  DeviceInput.swift
//  videoTest
//
//  Created by xiaoqiang cao on 7/1/18.
//  Copyright © 2018 xiaoqiang cao. All rights reserved.
//

import AVFoundation

class DeviceInput: NSObject{
    //    front wild cam
    var frontWildAngleCamera: AVCaptureDeviceInput?
    
    //    back wild cam
    var backWildAngleCamera: AVCaptureDeviceInput?
    
    //back tel cam
    var backTelephotoCamera: AVCaptureDeviceInput?
    
    var backDualCamera: AVCaptureDeviceInput?
    
    var microphone: AVCaptureDeviceInput?
    
    func getAllCameras(){
        let cameraDevices = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera, .builtInTelephotoCamera, .builtInDualCamera], mediaType: .video, position: .unspecified).devices
        
        for camera in cameraDevices{
            let inputDevice = try! AVCaptureDeviceInput(device: camera)
            
            if camera.deviceType == .builtInWideAngleCamera, camera.position == .front{
                frontWildAngleCamera = inputDevice
            }
            
            if camera.deviceType == .builtInWideAngleCamera, camera.position == .back{
                backWildAngleCamera = inputDevice
            }
            
            if camera.deviceType == .builtInTelephotoCamera{
                backWildAngleCamera = inputDevice
            }
            
            if camera.deviceType == .builtInDualCamera{
                backDualCamera = inputDevice
            }
        }
    }
    
    func getMicrophone(){
        if let mic = AVCaptureDevice.default(for: .audio){
            microphone = try! AVCaptureDeviceInput(device: mic)
        }
    }
    override init() {
        super.init()
        getAllCameras()
        getMicrophone()
    }
}
