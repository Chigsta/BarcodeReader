//
//  ScannerViewController.swift
//  BarcodeReader
//
//  Created by Chiraag Patel on 01/04/2020.
//  Copyright © 2020 Chiraag Patel. All rights reserved.
//

import UIKit
import AVFoundation
import Vision

class ScannerViewController: UIViewController {
    
    
    @IBOutlet weak var customCameraView: UIView!
    
    var rootLayer: CALayer! = nil
    var previewLayer: AVCaptureVideoPreviewLayer! = nil
    let captureSession = AVCaptureSession()
    let videoDataOutput = AVCaptureVideoDataOutput()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = UIColor.gray
        displayCustomCameraView()
        self.videoDataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "Sample Buffer"))
        
        
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
        
        //        let viewHeight = self.view.frame.height
        //        let viewWidth = self.view.frame.width
        //        let cameraFrameHeight = viewHeight/2
        //        let cameraFramWidth = viewWidth
        //let previewCameraFrame = customCameraView.bounds
        
        
        //Create a capture session
        
        
        
        // Create a DrawLine Instance to Draw View Finder on camera
        // let drawLine = DrawLine(frame: previewCameraFrame)
        
        
        //Begin configuration
        captureSession.beginConfiguration()
        
        
        //Find the default video device
        //        guard let videoDevice = AVCaptureDevice.default(for: .video) else {
        //            fatalError("Could not find default video device")
        //        }
        
        guard let videoDevice = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .back).devices.first else {
            fatalError("Could not find suitable video device")
        }
        
        
        do {
            try videoDevice.lockForConfiguration()
            videoDevice.focusMode = .continuousAutoFocus
            videoDevice.unlockForConfiguration()
            
            
        } catch {
            print(error.localizedDescription)
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
        
        
        
        
        
        guard captureSession.canAddOutput(videoDataOutput) else {
            fatalError("Can not find photo output")
        }
        
        captureSession.sessionPreset = .vga640x480
        
        captureSession.addOutput(videoDataOutput)
        
        captureSession.commitConfiguration()
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer?.videoGravity = .resizeAspectFill
        previewLayer.connection?.videoOrientation = .portrait
        
        rootLayer = customCameraView.layer
        previewLayer?.frame = rootLayer.bounds
        rootLayer.addSublayer(previewLayer)
        
        
        
        
        captureSession.startRunning()
        
        
    }
    
}

// MARK: - Caputure video frame methods

extension ScannerViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            fatalError("Could not get imageBuffer")
        }
        
        let ciImage = CIImage(cvImageBuffer: imageBuffer)
        print(ciImage)
        
        processImage(using: ciImage)
        
        
    }
    
}

// MARK: - Create Vision Request

extension ScannerViewController {
    
    // Create an Image Request Handler
    func processImage(using ciImage: CIImage) {
        
        let imageRequestHandler = VNImageRequestHandler(ciImage: ciImage)
        
        // Create request
        
        let detectBarcodeRequest = [VNDetectBarcodesRequest(completionHandler: { (request, error) in
            
            
            if let results = request.results as? [VNBarcodeObservation] {
                
                if results.count > 0 {
                    
                    self.captureSession.stopRunning()
                    print(results)
                }
                
                
                
            }
            
            
        })]
        
        do {
            try imageRequestHandler.perform(detectBarcodeRequest)
            
        } catch {
            print(error.localizedDescription)
        }
        
        
    }
}
