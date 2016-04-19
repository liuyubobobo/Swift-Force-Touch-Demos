//
//  DoodleView.swift
//  DoodleDemo
//
//  Created by Yuan Zhang on 12/6/15.
//  Copyright © 2015 Yubo Liu. All rights reserved.
//

import UIKit

class DoodleView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    var color: UIColor!{
        didSet{
           //print( "current color is \(color)")
           return
        }
    }
    private var drawData:[ ( points:Array<(loc:CGPoint,width:CGFloat)> , color:String ) ] = []
    
    private var lastPoint: CGPoint = CGPointZero
    
    private let defaultLineWidth: CGFloat = 5.0
    private let forceMultifier: CGFloat = 5.0
    
    override func drawRect(rect: CGRect) {
        
        if let ctx = UIGraphicsGetCurrentContext(){
            
            //CGContextSetLineJoin(ctx, CGLineJoin.Bevel)
            CGContextSetLineCap(ctx, .Round)
            for data in self.drawData{
                
                CGContextSetStrokeColorWithColor(ctx, LYBColor(hex:data.color)!.uiColor.CGColor )
                
                let points = data.points
                for i in 1..<points.count{
                    CGContextMoveToPoint(ctx, points[i-1].loc.x, points[i-1].loc.y)
                    CGContextSetLineWidth(ctx, points[i].width)
                    CGContextAddLineToPoint(ctx, points[i].loc.x, points[i].loc.y)
                    CGContextStrokePath(ctx)
                }
                
            }
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if let touch = touches.first{
            
            self.lastPoint = touch.locationInView(self)
            self.drawData.append( ( points:[(loc:self.lastPoint,width:self.defaultLineWidth)],
                                    color:self.color.lybColor.hex ) )
            
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if let touch = touches.first{
            
            var width = self.defaultLineWidth
            if #available(iOS 9.0, *) {
                if traitCollection.forceTouchCapability == UIForceTouchCapability.Available{
                    width = touch.force * self.forceMultifier
                }
            }
            
            self.lastPoint = touch.locationInView(self)
            self.drawData[self.drawData.count-1].points.append( (loc:lastPoint,width:width) )
            self.setNeedsDisplay()
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        self.lastPoint = CGPointZero
        
//        for data in drawData{
//            print( data.color )
//        }
    }
    
    func clearAll(){
        self.drawData.removeAll()
        self.setNeedsDisplay()
    }
}
