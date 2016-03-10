//
//  BackgroundView.swift
//  Stormy
//
//  Created by Phillip Paik on 2/25/16.
//  Copyright © 2016 Phillip Paik. All rights reserved.
//

import UIKit

class BackgroundView: UIView {

    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Background View
        
        //// Color Declarations
        let lightPurple: UIColor = UIColor(red: 0.2353, green: 0.7451, blue: 0.949, alpha: 1.0)
        let darkPurple: UIColor = UIColor(red: 0.102, green: 0.3804, blue: 0.8, alpha: 1.0)
        
        let context = UIGraphicsGetCurrentContext()
        
        //// Gradient Declarations
        let purpleGradient = CGGradientCreateWithColors(CGColorSpaceCreateDeviceRGB(), [lightPurple.CGColor, darkPurple.CGColor], [0, 1])
        
        //// Background Drawing
        let backgroundPath = UIBezierPath(rect: CGRectMake(0, 0, self.frame.width, self.frame.height))
        CGContextSaveGState(context)
        backgroundPath.addClip()
        CGContextDrawLinearGradient(context, purpleGradient,
            CGPointMake(160, 0),
            CGPointMake(160, 568),
            [.DrawsBeforeStartLocation, .DrawsAfterEndLocation])
        CGContextRestoreGState(context)
    }


}
