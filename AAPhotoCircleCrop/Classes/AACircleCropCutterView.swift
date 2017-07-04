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

        let padding: CGFloat = 25
        let scaledSize: CGSize

        if imageSize.width > rect.width - padding*2 {
            let factor = (rect.width - padding*2) / imageSize.width
            scaledSize = CGSize(width: imageSize.width * factor, height: imageSize.height * factor)
        } else {
            scaledSize = imageSize
        }


        let newRect = CGRect(x: rect.size.width/2 - scaledSize.width/2, y: rect.size.height/2 - scaledSize.height/2, width: scaledSize.width, height: scaledSize.height)
        let path = UIBezierPath(rect: newRect)
        context?.setBlendMode(.clear)
        UIColor.clear.setFill()
        path.fill()

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
