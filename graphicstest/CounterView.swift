//
//  CounterView.swift
//  graphicstest
//
//  Created by Gemma Barrett on 01/09/2015.
//  Copyright (c) 2015 Gem Barrett. All rights reserved.
//

import UIKit

// target of things
var percentageMeasure = 100
let π:CGFloat = CGFloat(M_PI)

@IBDesignable class CounterView: UIView {
    
    @IBInspectable var counter: Int = 0 {
        didSet {
            if counter <= percentageMeasure {
                setNeedsDisplay()
            }
        }
    }
    @IBInspectable var outlineColour: UIColor = UIColor.blueColor()
    @IBInspectable var counterColour: UIColor = UIColor.orangeColor()

    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // pointy bit of the compass
        let center = CGPoint(x:bounds.width/2, y:bounds.height/2)
        // open the arm of the compass to desired radius
        let radius: CGFloat = max(bounds.width, bounds.height)
        // add a pen to the compass arm
        let counterWidth: CGFloat = 46
        // start and end points of the line
        let startingPoint: CGFloat = 4*π/4
        let endingPoint: CGFloat = 0*π/4
        // create path based on previous settings
        var counterPath = UIBezierPath(arcCenter: center,
            radius: radius/2 - counterWidth/2,
            startAngle: startingPoint,
            endAngle: endingPoint,
            clockwise: true)
        counterPath.lineWidth = counterWidth
        counterColour.setStroke()
        counterPath.stroke()
        
        
        // difference between two angles
        let angleDiff: CGFloat = 2 * π - startingPoint + endingPoint
        // arc for single portion
        let counterLengthPerThing = angleDiff / CGFloat(percentageMeasure)
        // define where the line ends, depending on current counter value
        let outlineEndAngle = counterLengthPerThing * CGFloat(counter) + startingPoint
        // draw outside line
        var outlineForPath = UIBezierPath(arcCenter: center,
            radius: bounds.width/2 - 2.5,
            startAngle: startingPoint,
            endAngle: outlineEndAngle,
            clockwise: true)
        // draw inside line
        outlineForPath.addArcWithCenter(center,
            radius: bounds.width/2 - counterWidth + 2.5,
            startAngle: outlineEndAngle,
            endAngle: startingPoint,
            clockwise: false)
        outlineForPath.closePath()
        outlineColour.setStroke()
        outlineForPath.lineWidth = 5.0
        outlineForPath.stroke()
    }
    

}
