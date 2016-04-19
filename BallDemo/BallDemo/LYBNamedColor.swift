//
//  LYBNamedColor.swift
//  ColorsByNameLite
//
//  Created by Yuan Zhang on 12/3/15.
//  Copyright © 2015 Yubo Liu. All rights reserved.
//

import UIKit

class LYBNamedColor : LYBColor {

    // TODO: not quite sure use this method to control access is the best way
    private var _colorName: String!
    var colorName: String{ return _colorName }
    
    init?(colorName: String, hex: String) {
        super.init(hex: hex)
        self._colorName = colorName
    }
    
    convenience init(colorName: String, color: UIColor){
        
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        self.init( colorName: colorName , red: Int(red*255) , green: Int(green*255) , blue: Int(blue*255) , alpha: Int(alpha*255) )!

    }
    
    init?(colorName: String, red: Int , green: Int , blue: Int , alpha: Int = 255){
        super.init(red: red, green: green, blue: blue, alpha: alpha)
        self._colorName = colorName
    }
    
    init?(colorName: String, hue: Float , saturation: Float , brightness: Float , alpha: Float = 1.0){
        super.init(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
        self._colorName = colorName
    }
    
    override var description: String{
        return self.colorName + " : " + self.hex
    }
}

