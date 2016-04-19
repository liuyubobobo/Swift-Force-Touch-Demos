//
//  Ball.swift
//  BallDemo
//
//  Created by Yuan Zhang on 12/7/15.
//  Copyright © 2015 Yubo Liu. All rights reserved.
//

import UIKit

class Ball : UIView{

    var color: LYBColor!{
        didSet{
            self.setNeedsDisplay()
        }
    }
    var elasticity: CGFloat!
    
    lazy var mass:CGFloat = {
        return 2*CGFloat(M_PI)*(self.frame.size.width/2.0)*(self.frame.size.width/2.0)
        //return self.frame.size.width
    }()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.clearColor()
    }
    
    init( frame: CGRect , color: LYBColor , elasticity: CGFloat = 1.0 ) {
        super.init(frame: frame)
        self.color = color
        self.elasticity = elasticity
        self.backgroundColor = UIColor.clearColor()
    }
    
    override var collisionBoundsType: UIDynamicItemCollisionBoundsType {
        return .Ellipse
    }
    
    override func drawRect(rect: CGRect) {
        
        if let ctx = UIGraphicsGetCurrentContext(){
            
            CGContextSetFillColorWithColor(ctx, color.uiColor.CGColor )
            CGContextFillEllipseInRect(ctx, rect)
            CGContextFillPath(ctx)
        }
    }
}

extension Ball : NSCopying{
    
    func copyWithZone(zone: NSZone) -> AnyObject {
        return Ball(frame: self.frame, color: LYBColor(hex: self.color.hex)!, elasticity: self.elasticity)
    }
}

extension Ball{
    
    static func randomBallInRect( rect: CGRect ) -> Ball{
        
        let radius = CGFloat(arc4random_uniform(40)) + 10
        let centerx = radius + CGFloat( arc4random_uniform(UInt32(rect.width-2*radius) ))
        let centery = radius + CGFloat( arc4random_uniform(UInt32(rect.height-2*radius) ))
        
        let randomColorIndex = Int( arc4random_uniform( UInt32(LYBNamedColors.colorCount) ) )
        let randomColor = LYBNamedColors.getLYBNamedColor(randomColorIndex)!
        
        let randomElasticity = 0.8 + CGFloat( arc4random_uniform(2) )/10.0
        
        return Ball(frame: CGRectMake(centerx-radius, centery-radius, 2*radius, 2*radius), color: randomColor , elasticity: randomElasticity )
        
    }
}
