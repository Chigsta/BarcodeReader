//
//  ViewController.swift
//  BarcodeReader
//
//  Created by Chiraag Patel on 24/03/2020.
//  Copyright © 2020 Chiraag Patel. All rights reserved.
//

import UIKit
import Vision
import CoreGraphics
import AVFoundation

class ViewController: UIViewController {
    
    
    
    // Outlets
 
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        let photoTap = UITapGestureRecognizer(target: self, action: #selector(promptPhoto))
        photoTap.numberOfTapsRequired = 2
        self.view.addGestureRecognizer(photoTap)
        customiseCaptureScreen()
    }
    
    
}

// MARK: - Select Photo

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc func promptPhoto() {
        
        
        // Create an Alert prompting user to select a option to pick an image
        let prompt = UIAlertController(title: "Choose A Photo", message: "Please choose an option", preferredStyle: .alert)
        
        // Functions to provide in the handler for addAction to allow camera, photo album, photo libray usuage
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        func presentCamera(_ _ : UIAlertAction) {
            imagePicker.sourceType = .camera
            present(imagePicker, animated: true, completion: nil)
        }
        
        func presentPhotoLibrary(_ _ : UIAlertAction) {
            imagePicker.sourceType = .photoLibrary
            present(imagePicker, animated: true, completion: nil)
        }
        
        func presentPhotoAlbum(_ _ : UIAlertAction) {
            imagePicker.sourceType = .savedPhotosAlbum
            present(imagePicker, animated: true, completion: nil)
        }
        
        // Actions to add to the promt alert
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: presentCamera)
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default, handler: presentPhotoLibrary)
        let photoAlbumAction = UIAlertAction(title: "Photo Album", style: .default, handler: presentPhotoAlbum)
        
        // Add actions with Function handler to the prompt
        
        prompt.addAction(cameraAction)
        prompt.addAction(photoLibraryAction)
        prompt.addAction(photoAlbumAction)
        
        self.present(prompt, animated: true, completion: nil)
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[.originalImage] as? UIImage {
            //displayPhoto.image = pickedImage
            let ciPickedImage = CIImage(image: pickedImage)!
            processImage(using: ciPickedImage)
            
        } else {
            fatalError("Image not found")
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    
}

// MARK: - Create Vision Request

extension ViewController {
    
    // Create an Image Request Handler
    func processImage(using ciImage: CIImage) {
        
        let imageRequestHandler = VNImageRequestHandler(ciImage: ciImage)
        
        // Create request
        
        let detectBarcodeRequest = [VNDetectBarcodesRequest(completionHandler: { (request, error) in
            
            if let results = request.results as? [VNBarcodeObservation] {
                
                print(results)
                print(results[0].barcodeDescriptor ?? fatalError())
                print(results[0].payloadStringValue!)
                print(results[0].symbology)
            }
            
            
        })]
        
        do {
            try imageRequestHandler.perform(detectBarcodeRequest)
        } catch {
            print(error.localizedDescription)
        }
        
        
    }
}


// MARK: - Customise Camera Capture Session

extension ViewController {
    
    func customiseCaptureScreen() {
        
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


