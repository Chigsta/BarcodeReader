//
//  ScannerViewController.swift
//  BarcodeReader
//
//  Created by Chiraag Patel on 01/04/2020.
//  Copyright © 2020 Chiraag Patel. All rights reserved.
//

import UIKit
import AVFoundation

class ScannerViewController: UIViewController {

    
    @IBOutlet weak var customCameraView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = UIColor.gray
        displayCustomCameraView()
        

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: - Customise Camera Capture Session

extension ScannerViewController {
    
    func displayCustomCameraView() {
        
        let viewHeight = self.view.frame.height
        let viewWidth = self.view.frame.width
        let cameraFrameHeight = viewHeight/2
        let cameraFramWidth = viewWidth
        let previewCameraFrame = CGRect(x: 0, y: viewHeight/2.5, width: cameraFramWidth, height: cameraFrameHeight)
        
        
        
        print(viewHeight, viewWidth)
        
        //Create a capture session
        let captureSession = AVCaptureSession()
        var previewLayer: AVCaptureVideoPreviewLayer?
        
        // Create a DrawLine Instance to Draw View Finder on camera
        let drawLine = DrawLine(frame: previewCameraFrame)
        drawLine.updateFrameDimension(frameHeight: cameraFrameHeight, frameWidth: cameraFramWidth)
        
        //Begin configuration
        captureSession.beginConfiguration()
        
        //Find the default video device
        guard let videoDevice = AVCaptureDevice.default(for: .video) else {
            fatalError("Could not find default video device")
        }
        
       
        
        do {
            //Wrap the vidioe device in a capture device input
            let videoDeviceInput = try AVCaptureDeviceInput(device: videoDevice)
            if captureSession.canAddInput(videoDeviceInput) {
                captureSession.addInput(videoDeviceInput)
            }
            
        } catch {
            print(error.localizedDescription)
        }
        
        let photoOutput = AVCapturePhotoOutput()
        
        guard captureSession.canAddOutput(photoOutput) else {
            fatalError("Can not find photo output")
        }
        
        captureSession.sessionPreset = .photo
        captureSession.addOutput(photoOutput)
        captureSession.commitConfiguration()
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        self.view.layer.addSublayer(previewLayer!)
        previewLayer?.videoGravity = .resize
        previewLayer?.frame = previewCameraFrame
        self.view.addSubview(drawLine)
        drawLine.setNeedsDisplay()
       
        
        
        captureSession.startRunning()
        
        
        
        
    }
    
}
