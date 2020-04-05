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
        
    }
    
}

// MARK: - Customise Camera Capture Session

extension ScannerViewController {
    
    func displayCustomCameraView() {
        
        // Begin configuration
        captureSession.beginConfiguration()
        
        // Find video device
        guard let videoDevice = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .back).devices.first else {
            fatalError("Could not find suitable video device")
        }
        
        //  Configure video device
        do {
            try videoDevice.lockForConfiguration()
            videoDevice.focusMode = .continuousAutoFocus
            videoDevice.unlockForConfiguration()
        } catch {
            print(error.localizedDescription)
        }
        
        // Add configured video device as input to the AVCaptureSession
        do {
            
            let videoDeviceInput = try AVCaptureDeviceInput(device: videoDevice)
            if captureSession.canAddInput(videoDeviceInput) {
                captureSession.addInput(videoDeviceInput)
            }
        } catch {
            print(error.localizedDescription)
        }
        
        // Add video data as an output to the ACCaptureSession
        guard captureSession.canAddOutput(videoDataOutput) else {
            fatalError("Can not find photo output")
        }
        
        captureSession.addOutput(videoDataOutput)
        
        // Configure capture session
        captureSession.sessionPreset = .vga640x480
        
        // Commit capture session configuration
        captureSession.commitConfiguration()
        
        // Create a preview to show cpature session on device and configure preview
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer?.videoGravity = .resizeAspectFill
        previewLayer.connection?.videoOrientation = .portrait
        
        // Add privew as sublayer to customCameraView bounds
        rootLayer = customCameraView.layer
        previewLayer?.frame = rootLayer.bounds
        rootLayer.addSublayer(previewLayer)
        
        // Start capture session
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
