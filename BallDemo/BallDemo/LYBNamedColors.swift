//
//  LYBColors.swift
//  ColorsByNameLite
//
//  Created by Yuan Zhang on 12/1/15.
//  Copyright © 2015 Yubo Liu. All rights reserved.
//

import UIKit

class LYBNamedColors{
    
    static private let colors: [LYBNamedColor] =
        [
            LYBNamedColor(colorName: "Black", hex: "#000000")!,         //0
            LYBNamedColor(colorName: "Red", hex: "#f44336")!,           //1
            LYBNamedColor(colorName: "Pink", hex: "#e91e63")!,          //2
            LYBNamedColor(colorName: "Deep Purple", hex: "#673ab7")!,   //3
            LYBNamedColor(colorName: "Indigo", hex: "#3f51b5")!,        //4
            LYBNamedColor(colorName: "Green", hex: "#4caf50")!,         //5
            LYBNamedColor(colorName: "Amber", hex: "#ffc107")!,         //6
            LYBNamedColor(colorName: "Deep Orange", hex: "#ff5722")!,   //7
            LYBNamedColor(colorName: "Brown", hex: "#795548")!,         //8
            LYBNamedColor(colorName: "Blue Grey", hex: "#607d8b")!,     //9
        ]
    
    static var colorCount:Int{
        return colors.count
    }
    
    static func getLYBNamedColor( index: Int ) -> LYBNamedColor?{
        
        guard index < colorCount else{
            return nil
        }
        
        return colors[index]
    }
    
}
