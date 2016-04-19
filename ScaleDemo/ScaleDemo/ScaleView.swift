//
//  ScaleView.swift
//  ScaleDemo
//
//  Created by Yuan Zhang on 12/6/15.
//  Copyright © 2015 Yubo Liu. All rights reserved.
//

import UIKit

class ScaleView: UIView {

    weak var parentViewController:ViewController!
    
    private var radius: CGFloat = 0.0
    var c: CGPoint = CGPointZero
    
    override func drawRect(rect: CGRect) {
        // Drawing code
        if let ctx = UIGraphicsGetCurrentContext(){
            
            CGContextSetFillColorWithColor(ctx, UIColor(red: 3.0/255.0, green: 169.0/255.0, blue: 244.0/255.0, alpha: 0.5).CGColor )
            CGContextFillEllipseInRect(ctx, CGRectMake(c.x - radius, c.y - radius , 2*radius, 2*radius))
            CGContextFillPath(ctx)
        }
        
//        if let ctx = UIGraphicsGetCurrentContext(){
//            
//            let circleColor = UIColor(red: 3.0/255.0, green: 169.0/255.0, blue: 244.0/255.0, alpha: 0.5)
//            CGContextSetFillColorWithColor(ctx, circleColor.CGColor )
//            
//            let r:CGFloat = 100.0
//            let circleBounding = CGRectMake( self.center.x - r, self.center.y - r , 2*r, 2*r)
//            CGContextFillEllipseInRect( ctx, circleBounding)
//            
//            CGContextFillPath(ctx)
//        }
    }
    
//    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        
//    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if let touch = touches.first{
            
            if traitCollection.forceTouchCapability == UIForceTouchCapability.Available{
                    
                let force = touch.force
                self.radius = force * 80
                self.c = touch.locationInView(self)
                
                self.setNeedsDisplay()
                self.parentViewController.updateWeightLabel( Float(force) )
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        radius = 0.0
        self.setNeedsDisplay()
        self.parentViewController.updateWeightLabel( 0.0 )
    }

}
