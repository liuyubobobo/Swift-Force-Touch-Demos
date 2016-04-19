//
//  ViewController.swift
//  BallDemo
//
//  Created by Yuan Zhang on 12/7/15.
//  Copyright © 2015 Yubo Liu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var balls:[Ball] = []
    
    var animator: UIDynamicAnimator!
    var gravity: UIGravityBehavior!
    var collision: UICollisionBehavior!
    
    var touchPoint: CGPoint = CGPointZero
    var newBall: Ball?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.start()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func reset(sender: UIBarButtonItem) {
        
        while !balls.isEmpty{
            let aBall = balls.popLast()
            aBall?.removeFromSuperview()
        }
        self.start()
    }
    
    private func start(){
        
        self.animator = UIDynamicAnimator(referenceView: self.view)
        
        self.gravity = UIGravityBehavior()
        self.collision = UICollisionBehavior()
        
        let INITIAL_BALL_CNT = 10
        for _ in 0..<INITIAL_BALL_CNT{
            let aBall = Ball.randomBallInRect(self.view.bounds)
            
            self.gravity.addItem(aBall)
            self.collision.addItem(aBall)
            
            balls.append(aBall)
            self.view.addSubview(aBall)
        }
        
        for i in 0..<INITIAL_BALL_CNT{
            //print("start \(i)")
            let bounce = UIDynamicItemBehavior(items: [balls[i]] )
            bounce.elasticity = balls[i].elasticity
            bounce.density = balls[i].mass
            self.animator.addBehavior(bounce)
            //print("end \(i)")
        }
        
        self.animator.addBehavior(gravity)
        
        self.collision.translatesReferenceBoundsIntoBoundary = true
        self.animator.addBehavior(collision)
    }
}


extension ViewController{
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if let touch = touches.first{
            self.touchPoint = touch.locationInView(self.view)
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if let touch = touches.first{
            
            if newBall == nil{
                newBall = Ball.randomBallInRect(self.view.bounds)
                newBall?.center = touchPoint
                self.view.addSubview(newBall!)
            }
            
            if traitCollection.forceTouchCapability == UIForceTouchCapability.Available{
                
                let r = touch.force * 10
                newBall?.frame = CGRectMake( touchPoint.x - r, touchPoint.y - r, 2*r, 2*r )
            }
            
            newBall?.setNeedsDisplay()
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        newBall?.removeFromSuperview()
        
        self.balls.append( (newBall?.copy())! as! Ball )
        //print( newBall! )
        //print( self.balls.last! )
        self.view.addSubview( balls.last! )
        
        self.gravity.addItem(self.balls.last!)
        self.collision.addItem(self.balls.last!)
        let itemBehavior = UIDynamicItemBehavior(items: [balls.last!])
        itemBehavior.elasticity = balls.last!.elasticity
        self.animator.addBehavior(itemBehavior)
        
        newBall = nil
    }
}

