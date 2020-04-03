//
//  DrawLine.swift
//  BarcodeReader
//
//  Created by Chiraag Patel on 28/03/2020.
//  Copyright © 2020 Chiraag Patel. All rights reserved.
//

import UIKit
import AVFoundation

class DrawLine: UIView {
    
    var frameHeight: CGFloat = 0.0
    var frameWidth: CGFloat = 0.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func draw(_ rect: CGRect) {
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: self.frameWidth))
        path.addLine(to: CGPoint(x: self.frameHeight, y: 0.0))
        UIColor.red.setStroke()
        path.lineWidth = 2.3
        path.stroke()
        print(self.frameWidth, self.frameHeight)
    }
    
    func updateFrameDimension(frameHeight: CGFloat, frameWidth: CGFloat) {
        
        self.frameHeight = frameHeight
        self.frameWidth = frameWidth
        
    }
    
}
