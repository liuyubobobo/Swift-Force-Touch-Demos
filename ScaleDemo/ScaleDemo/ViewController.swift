//
//  ViewController.swift
//  ScaleDemo
//
//  Created by Yuan Zhang on 12/6/15.
//  Copyright © 2015 Yubo Liu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var scaleView: ScaleView!
    @IBOutlet weak var weightLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        scaleView.parentViewController = self
        self.updateWeightLabel(0.00)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func updateWeightLabel( force: Float ){
        
        let weightString = NSString(format: "%.2f", force*57.6) as String
        weightLabel.text = weightString + " g"
        
        //weightLabel.text = "\(force)"
    }
}

