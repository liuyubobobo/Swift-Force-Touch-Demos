//
//  ViewController.swift
//  DoodleDemo
//
//  Created by Yuan Zhang on 12/6/15.
//  Copyright © 2015 Yubo Liu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var colorButtons: [UIButton]!
    @IBOutlet weak var doodleView: DoodleView!
    
    var selectedColorIndex = 0{
        didSet{
            self.colorButtons?[oldValue].layer.borderColor = LYBNamedColors.getLYBNamedColor(oldValue)?.uiColor.CGColor
            self.colorButtons?[selectedColorIndex].layer.borderColor = UIColor.whiteColor().CGColor
            self.doodleView.color = LYBNamedColors.getLYBNamedColor(selectedColorIndex)?.uiColor
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.configureColorButtons()
        self.selectedColorIndex = 0
    }
    
    private func configureColorButtons(){
    
        for i in 0..<LYBNamedColors.colorCount{
            self.colorButtons[i].setTitle("", forState: .Normal)
            self.colorButtons[i].backgroundColor = LYBNamedColors.getLYBNamedColor(i)?.uiColor
            self.colorButtons[i].layer.borderWidth = 5.0
            self.colorButtons[i].layer.borderColor = LYBNamedColors.getLYBNamedColor(i)?.uiColor.CGColor
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.All
    }

    @IBAction func colorChanged(sender: UIButton) {
        
        for i in 0..<LYBNamedColors.colorCount{
            
            if sender.backgroundColor?.lybColor == LYBNamedColors.getLYBNamedColor(i){
                //print("color changed to \(i)")
                self.selectedColorIndex = i
                break
            }
        }
    }
    
    @IBAction func clearAll(sender: UIBarButtonItem) {
        self.doodleView.clearAll()
    }

}

