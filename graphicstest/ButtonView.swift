//
//  ButtonView.swift
//  graphicstest
//
//  Created by Gemma Barrett on 31/08/2015.
//  Copyright (c) 2015 Gem Barrett. All rights reserved.
//

//48, 95, 128
import UIKit

@IBDesignable

class ButtonView: UIButton {
    @IBInspectable var fillColour: UIColor = UIColor(red: 0.18, green: 0.37, blue: 0.50, alpha: 1.0)
    @IBInspectable var isIncreaseButton: Bool = true
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // oval-shaped path, size of rectangle (100x100) so circle
        var newPath = UIBezierPath(rect: rect)
        var path = UIBezierPath(ovalInRect: rect)
        // set fill colour through IBInspectable
        fillColour.setFill()
        // fill the path
        path.fill()
        
        
        // drawing line: set start position on left and draw to end position on right, then set stroke color
        // dimensions for the horizontal stroke
        let crossHeight: CGFloat = 3.0
        let crossWidth: CGFloat = min(bounds.width, bounds.height) * 0.6
        // create path
        var crossPath = UIBezierPath()
        // path's width equal to height of stroke
        crossPath.lineWidth = crossHeight
        // draw horizontal line from starting point
        crossPath.moveToPoint(CGPoint(
            x:bounds.width/2 - crossWidth/2 + 0.5,
            y:bounds.height/2 + 0.5))
        // to ending point
        crossPath.addLineToPoint(CGPoint(
            x:bounds.width/2 + crossWidth/2 + 0.5,
            y:bounds.height/2 + 0.5))
        
        // make vertical line conditional in case just need horizontal
        if isIncreaseButton {
            // draw vertical line from starting point
            crossPath.moveToPoint(CGPoint(
                x:bounds.width/2 + 0.5,
                y:bounds.height/2 - crossWidth/2 + 0.5))
            // to ending point
            crossPath.addLineToPoint(CGPoint(
                x:bounds.width/2 + 0.5,
                y:bounds.height/2 + crossWidth/2 + 0.5))
        }
        // stroke colour set
        UIColor.whiteColor().setStroke()
        // draw the bloody thing!
        crossPath.stroke()
    }
    

}
