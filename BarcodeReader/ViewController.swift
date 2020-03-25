//
//  ViewController.swift
//  BarcodeReader
//
//  Created by Chiraag Patel on 24/03/2020.
//  Copyright © 2020 Chiraag Patel. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let photoTap = UITapGestureRecognizer(target: self, action: #selector(promptPhoto))
        photoTap.numberOfTapsRequired = 2
        self.view.addGestureRecognizer(photoTap)
        
        
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
        
        if let image = info[.originalImage] as? UIImage {
           print(image)
        } else {
            fatalError("Image not found")
        }
        
    }
}
