//
//  AACircleCropCutterView.swift
//
//  Created by Keke Arif on 21/02/2016.
//  Modified by Andrea Antonioni on 14/01/2017
//  Copyright © 2017 Andrea Antonioni. All rights reserved.
//

import UIKit

class AACircleCropCutterView: UIView {

    var imageSize: CGSize = CGSize(width: 240, height: 240) {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isOpaque = false
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.isOpaque = false
    }

    override func draw(_ rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext()
        
        UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.7).setFill()
        UIRectFill(rect)

        // Draw a rectangle around the circle, just to see the effective cutted image
        let square = UIBezierPath(rect: CGRect(x: rect.size.width/2 - imageSize.width/2, y: rect.size.height/2 - imageSize.height/2, width: imageSize.width, height: imageSize.height))
        context?.setBlendMode(.clear)
        UIColor.clear.setFill()
        square.fill()

    }

    // Allow touches through the circle crop cutter view
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        for subview in subviews as [UIView] {
            if !subview.isHidden && subview.alpha > 0 && subview.isUserInteractionEnabled && subview.point(inside: convert(point, to: subview), with: event) {
                return true
            }
        }
        return false
    }
    
}
