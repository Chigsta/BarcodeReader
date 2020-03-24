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
        
        let photoTap = UITapGestureRecognizer(target: self, action: #selector(hello))
        photoTap.numberOfTapsRequired = 2
        self.view.addGestureRecognizer(photoTap)
        
        
    }
    
    @objc func hello() {
        print("Hello")
    }


}

